# Ostra VM Environment

This is our environment to develop the main Ostra Smart Contract,
we're using Brownie and Ganache (UI App) with a Mainnet Fork.

- BSC Public RPC Node replaced by a [Moralis](https://moralis.io/) Speedy Node
- Using a BSC Mainnet Fork (Block N°[13267500](https://explorer.bitquery.io/bsc/block/13267500))
- Solidity 0.8.10 (Updated libraries)

### Environment Updates:
- Pyprint functions for debugging purpose
- Pyprint now supports no title & auto-initialization
- Pyprint now matches Brownie Console colors (Using [Colorama](https://pypi.org/project/colorama/))
- Pyprint now supports Numbers (en-US) and balance percentages
- Smart Contract Size script that checks the current size of the Contract
- Automatic PancakeSwap Router

### Contract Proxies Method:
- Using [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535) Diamonds, Multi-Facet Proxy pattern standard
- Diamonds standard implementations reference [Github repository](https://github.com/mudgen/diamond)
- We're using the [diamond-2](https://github.com/mudgen/diamond-2-hardhat) reference implementation
- [Louper](https://louper.dev/) can be used to check the facets off-chain

### Libraries:
- Context.sol
- Ownable.sol
- IBEP20.sol
- IPancake.sol (Pair & Factory)
- Address.sol
- SafeMath.sol (0.8+, Overflow is now natively supported by Solidity)
