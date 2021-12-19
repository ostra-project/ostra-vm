# Ostra VM Environment

This is our environment to develop the main Ostra Smart Contract,
we're using Brownie and Ganache (UI App) with a Mainnet Fork.

- BSC Public RPC Node replaced by a [Moralis](https://moralis.io/) Speedy Node
- Using a BSC Mainnet Fork (Block N°[13611400](https://explorer.bitquery.io/bsc/block/13611400))
- Solidity 0.8.10 (Updated libraries)

### Environment Updates:
- Pyprint functions for debugging purpose
- Pyprint now supports no title & auto-initialization
- Pyprint now matches Brownie Console colors (Using [Colorama](https://pypi.org/project/colorama/))
- Pyprint now supports Numbers (en-US) and balance percentages
- Smart Contract Size script that checks the current size of the Contract
- Automatic PancakeSwap Router

### Contract Proxy:
- Using [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535) Diamonds, Multi-Facet Proxy pattern standard
- Diamonds standard implementations reference [Github repository](https://github.com/mudgen/diamond)
- Based on the [diamond-2](https://github.com/mudgen/diamond-2-hardhat) reference implementation
- [Louper](https://louper.dev/) can be used to check the facets off-chain

### Libraries:
- SafeMath Lib (0.8+, Overflow is now natively supported by Solidity)
- Ownable Contract (Replaced later by a DAO System)
- IPancake Interface (Pair & Factory)
- Context Contract
- IBEP20 Interface

### API:
- Diamond Facet specifically made for an API Endpoint
- Contract with `external view` functionnalities which can be called without any gas needed
- Can be used by an API Endpoint which could save multiple Historical Data
