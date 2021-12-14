// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (contracts/utils/Context.sol)
// MODIFIED VERSION

pragma solidity ^0.8.10;


// Modifications:
// 'address'            -> 'address payable'
// 'msg.sender'         -> 'payable(msg.sender)'
// 'bytes calldata'     -> 'bytes memory'
// 'this;'              -> Silence state mutability warning without generating bytecode (https://github.com/ethereum/solidity/issues/2691)
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}
