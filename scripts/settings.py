from colorama import Fore
from brownie import network


# Contract
contractName = 'Diamond'
contractSizeLimit = 24 * 1024
contractDecimals = 10**8

# Pyprint
pyprintColor = Fore.LIGHTBLUE_EX
pyprintRounding = 4

# Brownie Connect
mainAccount = ['real-account']
defAccountIndex = 0
localEnv = ["bsc-fork"]
mainEnv = ["bsc-main"]
pancakeMainnet = '0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F'
pancakeTestnet = '0xD99D1c33F9fC3444f8101754aBC46c52416550D1'

# Active Network
# Auto PancakeSwap Router (Mainnet & Mainnet Fork OR Testnet)
activeNetwork = network.show_active()
if activeNetwork in localEnv or activeNetwork in mainEnv:
    pancakeRouter = pancakeMainnet
else:
    pancakeRouter = pancakeTestnet
