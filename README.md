# Ostra VM Environment

This is our environment to develop the main Ostra Smart Contract,
we're using Brownie and Ganache (UI App) with a Mainnet Fork.

- BSC Public RPC Node replaced by a [Moralis](https://moralis.io/) Speedy Node
- Using a BSC Mainnet Fork (Block N°[13267500](https://explorer.bitquery.io/bsc/block/13267500))

### Environment Updates:
- Pyprint functions for debugging purpose
- Pyprint now supports no title & auto-initialization
- Smart Contract Size script that checks the current size of the Contract

### Contract Proxies Method:
- Using [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535) Diamonds, Multi-Facet Proxy pattern standard
- You can also check the Diamonds standard implementations example [Github repository](https://github.com/mudgen/diamond)
- We're using the [diamond-2](https://github.com/mudgen/diamond-2-hardhat) implementation
