from colorama import Fore
from brownie import network


# Contract
contractName = 'Ostra'
contractSizeLimit = 24 * 1024
contractDecimals = 10**8

# Pyprint
pyprintTitle = 'DEBUG ZONE'
pyprintColor = Fore.LIGHTBLUE_EX
pyprintRounding = 4

# Brownie Connect
defAccountIndex = 1
userAccount = ['real-account', 'matrix-account']

# Test Wallets
testWallet01 = '0x0A5C946949b4cc1a80E332Aa89ACC5aa9017E206'
testWallet02 = '0x2c211b0EdC9449673385209651845bE6d7d003f2'

# Blockchains
localBSC = 'bsc-fork'
testBSC = 'bsc-test'
mainBSC = 'bsc-main'

# Active Network
# Auto PancakeSwap Router (Mainnet & Mainnet-Fork OR Testnet)
pancakeMainnet = '0x10ED43C718714eb63d5aA57B78B54704E256024E'
pancakeTestnet = '0xd99d1c33f9fc3444f8101754abc46c52416550d1'
activeNetwork = network.show_active()
if (activeNetwork == localBSC or activeNetwork == mainBSC):
    pancakeRouter = pancakeMainnet
elif (activeNetwork == testBSC):
    pancakeRouter = pancakeTestnet
