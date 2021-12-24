from colorama import Fore
from brownie import network


# Contract
# By default, contract_size.py is in the scripts/utils folder,
# which means that the default path is actually ../build/contracts
# contractName -> 'contract_size.py' script checks the ./build/contracts/contractName.json file deployedBytecode key
# contractSizeLimit -> Default Ethereum Smart Contract size limit is 24KB
# contractDecimals -> Decimals (Min amount of the token) allows pyprint to automatically divide numbers
contractName = 'Main'
contractFolder = '../build/contracts/'
contractSizeLimit = 24 * 1024
contractDecimals = 10**8


# Pyprint
pyprintTitle = 'DEBUG ZONE'
pyprintColor = Fore.LIGHTBLUE_EX
pyprintRounding = 4


# Brownie Connect
defAccountIndex = 0  # Default index in the array of account names
userAccount = ['real-account']  # Brownie encrypted account names


# Test Wallets
# Generated from https://vanity-eth.tk/
testWallets = [
    '0x0A5C946949b4cc1a80E332Aa89ACC5aa9017E206',
    '0x2c211b0EdC9449673385209651845bE6d7d003f2',
    '0x0dcBd09De3335181EeB5DC8A0aF29807186aB87a',
    '0x5A9310629F9f9320b7E7E66c2de40367a0B3856d'
]


# Blockchains
localBSC = 'bsc-fork'  # A fork from the BSC Mainnet
testBSC = 'bsc-test'  # BSC Testnet
mainBSC = 'bsc-main'  # BSC Mainnet


# Active Network
# Auto PancakeSwap Router (Mainnet & Mainnet-Fork OR Testnet)
pancakeMainnet = '0x10ED43C718714eb63d5aA57B78B54704E256024E'
pancakeTestnet = '0xd99d1c33f9fc3444f8101754abc46c52416550d1'
activeNetwork = network.show_active()
if (activeNetwork == localBSC or activeNetwork == mainBSC):
    pancakeRouter = pancakeMainnet
elif (activeNetwork == testBSC):
    pancakeRouter = pancakeTestnet
