from colorama import Fore
from brownie import network


# Contract
# By default, contract_size.py is in the scripts/utils folder,
# which means that the default path is actually ../build/contracts
# contractName -> 'contract_size.py' script checks the ./build/contracts/contractName.json file deployedBytecode key
# contractSizeLimit -> Default Ethereum Smart Contract size limit is 24KB
# contractDecimals -> Decimals (Min amount of the token) allows pyprint to automatically divide numbers
contractName = 'Ostra'
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
    '0xD0583e2195E866d9E773C4Ef6Ba21BdDa3732b7B',
    '0x7eC0BfD42eA25f3826668C0574249D8e87cceB38',
    '0x509f3d0D9abCDc94F3189E35322F7D655e0872e1',
    '0xB5318747A65398f8EEcB303805f3176D7e0F5291'
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
