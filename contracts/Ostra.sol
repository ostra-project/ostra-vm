// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;


import "./interfaces/IBEP20.sol";
import "./interfaces/IUniswapV2.sol";
import "./contracts/Ownable.sol";
import "./libraries/Address.sol";
import "./libraries/SafeMath.sol";


contract Ostra is Context, IBEP20, Ownable {
    // Libs
    using SafeMath for uint256;
    using Address for address;

    // Mappings
    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcluded;

    // Enums
    enum ExcludedFromFee {TOEXCLUDED, FROMEXCLUDED, BOTHEXCLUDED, STANDARD}

    // Events
    event Burn(address account, uint256 amount);
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);

    // Arrays
    address[] private _excluded;

    // Private Undefined Variables
    uint256 private _tRetribTotal;
    uint256 private _tBurnTotal;
    uint256 private _tLiquidityTotal;
    bool inSwapAndLiquify;

    // User Defined Variables
    string private _NAME = "Ostra";
    string private _SYMBOL = "OSTRA";
    uint8 private _DECIMALS = 8;  // (10**_DECIMALS)

    uint256 private constant MAX = ~uint256(0);
    uint256 private _GRANULARITY = 100;

    uint256 private _tTotal = 1000000 * 10**6 * 10**8;  // Total Supply: 1,000,000,000,000
    uint256 public _maxTxAmount = 5000 * 10**6 * 10**8;  // Max Tx Amount: 5,000,000,000 (0.5%)
    uint256 private numTokensSellToAddToLiquidity = 500 * 10**6 * 10**8;  // Swap And Liquify: 50,000,000

    bool public swapAndLiquifyEnabled = true;

    // Calculated Values
    uint256 private _rTotal = (MAX - (MAX % _tTotal));

    // Structs
    struct Fee { 
        uint256 liquidity;
        uint256 retrib;
        uint256 burn;
    }
    
    // Fee
    Fee public _fees = Fee(2, 3, 2);
    Fee private origFees;
    
    // Addresses
    address public liquidityWallet = address(this);
    address public uniswapV2Pair;

    // Uniswap Routers
    IUniswapV2Router02 public uniswapV2Router;

    // Swap And Liquify
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }


    constructor (address tokenOwner, address router) payable {
        origFees = _fees;
		_owner = tokenOwner;
        _rOwned[tokenOwner] = _rTotal;

        IUniswapV2Router02 _newPancakeRouter = IUniswapV2Router02(router);

        // Create a Uniswap pair for this token
        uniswapV2Pair = IUniswapV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
        uniswapV2Router = _newPancakeRouter;

        // Exclude Owner / Contract from Fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;

        emit Transfer(address(0), tokenOwner, _tTotal);
    }


    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;

        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
                return (_rTotal, _tTotal);
                
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }

        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _burn(address account, uint256 amount) private {
        require(account != address(0), "BEP20: cannot burn from the zero address");

        uint256 currentRate = _getRate();
        uint256 rAmount = amount.mul(currentRate);
        _rOwned[account] = _rOwned[account].sub(rAmount, "BEP20: cannot burn below zero");

        if (_isExcluded[account])
            _tOwned[account] = _tOwned[account].sub(amount, "BEP20: cannot burn below zero");

        _tBurnTotal = _tBurnTotal.add(amount);
        _tTotal = _tTotal.sub(amount, "Cannot substract from total");
        _rTotal = _rTotal.sub(rAmount, "Cannot substract from rTotal");

        emit Burn(account, amount);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);

        if (_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }
 
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _reflectFee(uint256 rFee, uint256 rBurn, Fee memory tFees) private {
        _rTotal = _rTotal.sub(rFee).sub(rBurn);
        _tRetribTotal = _tRetribTotal.add(tFees.retrib);

        _tBurnTotal = _tBurnTotal.add(tFees.burn);
        _tLiquidityTotal = _tLiquidityTotal.add(tFees.liquidity);

        _tTotal = _tTotal.sub(tFees.burn);

        _burn(address(this), tFees.burn);
    }

    function _getTValues(uint256 tAmount, Fee memory fees) private view returns (Fee memory) {
        Fee memory tFees;

        tFees.liquidity = ((tAmount.mul(fees.liquidity)).div(_GRANULARITY)).div(100);
        tFees.retrib = ((tAmount.mul(fees.retrib)).div(_GRANULARITY)).div(100);
        tFees.burn = ((tAmount.mul(fees.burn)).div(_GRANULARITY)).div(100);
        
        return (tFees);
    }

    function _getTTransferAmount(uint256 tAmount, Fee memory tFees) private pure returns (uint256) {
        return tAmount.sub(tFees.liquidity).sub(tFees.retrib).sub(tFees.burn);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        return (rAmount, rFee);
    }

    function _getRTransferAmount(uint256 rAmount, uint256 rFee, Fee memory tFees, uint256 currentRate) private pure returns (uint256) {
        uint256 rBurn = tFees.burn.mul(currentRate);
        uint256 rLiquidity = tFees.liquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee + rLiquidity + rBurn);
        return rTransferAmount;
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, Fee memory) {
        Fee memory tFees = _getTValues(tAmount, _fees);

        uint256 tTransferAmount = _getTTransferAmount(tAmount, tFees);
        uint256 currentRate = _getRate();

        (uint256 rAmount, uint256 rFee) = _getRValues(tAmount, tFees.retrib, currentRate);
        uint256 rTransferAmount = _getRTransferAmount(rAmount, rFee, tFees, currentRate);

        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFees);
    }

    function _standardTransferContent(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    }

    function _excludedFromTransferContent(address sender, address recipient, uint256 tTransferAmount, uint256 rAmount, uint256 rTransferAmount) private {
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
    }

    function _excludedToTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 rTransferAmount) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
    }

    function _bothTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
    }

    function _getLiquidityFee() private view returns(uint256) {
        return _fees.liquidity;
    }

    function _getRetribFee() private view returns(uint256) {
        return _fees.retrib;
    }

    function _getBurnFee() private view returns(uint256) {
        return _fees.burn;
    }

    function _removeFees() private {
        if (_fees.liquidity == 0 && _fees.retrib == 0 && _fees.burn == 0) return;

        origFees = _fees;

        _fees.liquidity = 0;
        _fees.retrib = 0;
        _fees.burn = 0;
    }

    function _restoreFees() private {
        _fees = origFees;
    }

    function _transferAction(address sender, address recipient, uint256 tAmount, ExcludedFromFee excludedFromFee) private {
        uint256 currentRate =  _getRate();

        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, Fee memory tFees) = _getValues(tAmount);

        uint256 rBurn = tFees.burn.mul(currentRate);

        if (excludedFromFee == ExcludedFromFee.STANDARD) {
            _standardTransferContent(sender, recipient, rAmount, rTransferAmount);    
        } else if (excludedFromFee == ExcludedFromFee.TOEXCLUDED) {
            _excludedFromTransferContent(sender, recipient, tTransferAmount, rAmount, rTransferAmount);
        } else if (excludedFromFee == ExcludedFromFee.FROMEXCLUDED) {
            _excludedToTransferContent(sender, recipient, tAmount, rAmount, rTransferAmount);
        } else if (excludedFromFee == ExcludedFromFee.BOTHEXCLUDED) {
            _bothTransferContent(sender, recipient, tAmount, rAmount, tTransferAmount, rTransferAmount); 
        }

        _takeLiquidity(tFees.liquidity);
        _reflectFee(rFee, rBurn, tFees);

        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
        if (!takeFee)
            _removeFees();
        
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferAction(sender, recipient, amount, ExcludedFromFee.FROMEXCLUDED);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferAction(sender, recipient, amount, ExcludedFromFee.TOEXCLUDED);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferAction(sender, recipient, amount, ExcludedFromFee.STANDARD);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferAction(sender, recipient, amount, ExcludedFromFee.BOTHEXCLUDED);
        } else {
            _transferAction(sender, recipient, amount, ExcludedFromFee.STANDARD);
        }
        
        if (!takeFee)
            _restoreFees();
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (from != owner() && to != owner())
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");

        uint256 contractTokenBalance = balanceOf(address(this));
        
        if (contractTokenBalance >= _maxTxAmount)
            contractTokenBalance = _maxTxAmount;
        
        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;

        if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            swapAndLiquify(contractTokenBalance);
        }

        bool takeFee = true;

        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee);
    }

    function name() public view returns (string memory) {
        return _NAME;
    }

    function symbol() public view returns (string memory) {
        return _SYMBOL;
    }

    function decimals() public view returns (uint8) {
        return uint8(_DECIMALS);
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");

        if (!deductTransferFee) {
            (uint256 rAmount, , , , ) = _getValues(tAmount);
            return rAmount;
        } else {
            ( ,uint256 rTransferAmount, , , ) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than `` reflections");

        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function totalRetribution() public view returns (uint256) {
        return _tRetribTotal;
    }

    function totalBurn() public view returns (uint256) {
        return _tBurnTotal;
    }

    function totalLiquidity() public view returns (uint256) {
        return _tLiquidityTotal;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }

    function burn(uint256 amount) public virtual returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");

        (uint256 rAmount, , , , ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tRetribTotal = _tRetribTotal.add(tAmount);
    }

    function excludeAccount(address account) external onlyOwner() {
        require(!_isExcluded[account], "Account is already excluded");

        if (_rOwned[account] > 0)
            _tOwned[account] = tokenFromReflection(_rOwned[account]);

        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function setIsExcludedFromFee(address account, bool state) external onlyOwner() {
        _isExcludedFromFee[account] = state;
    }

    function includeAccount(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already included");

        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function updateFee(uint256 _liquidityFee, uint256 _retribFee, uint256 _burnFee) onlyOwner() public {
		require(_liquidityFee < 100 && _retribFee < 100 && _burnFee < 100);

        _fees.liquidity = _liquidityFee * 100;
        _fees.retrib = _retribFee * 100;
        _fees.burn = _burnFee * 100;
		
        origFees = _fees;
	}

    function setNumTokensSellToAddToLiquidity(uint256 swapNumber) public onlyOwner {
        numTokensSellToAddToLiquidity = swapNumber * 10 ** _DECIMALS;
    }

    function setMaxTxPercent(uint256 maxTxPercent) public onlyOwner {
        _maxTxAmount = maxTxPercent  * 10 ** _DECIMALS;
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // Approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // Add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,  // Slippage is unavoidable
            0,  // Slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // Generate the uniswap pair path of token -> WETH
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // Make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,  // Accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // Capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        swapTokensForEth(half); // Breaks the ETH
        uint256 newBalance = address(this).balance.sub(initialBalance);
        addLiquidity(otherHalf, newBalance);
        
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }
}