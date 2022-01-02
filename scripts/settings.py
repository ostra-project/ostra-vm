from colorama import Fore
from brownie import network


# Contract
# By default, contract_size.py is in the scripts/utils folder,
# which means that the default path is actually ../build/contracts
# contract_name -> 'contract_size.py' script checks the ./build/contracts/contract_name.json file deployedBytecode key
# contract_folder -> Default folder of the compiled contract (Brownie use the 'build/' by default
# contract_size_limit -> Default Ethereum Smart Contract size limit is 24KB
# contract_decimals -> Decimals (Min amount of the token) allows pyprint to automatically divide numbers
contract_name = 'Ostra'
contract_folder = '../build/contracts/'
contract_size_limit = 24 * 1024
contract_decimals = 10**8


# Pyprint
pyprint_title = 'DEBUG ZONE'
pyprint_color = Fore.LIGHTBLUE_EX
pyprint_rounding = 4


# Brownie Connect
def_account_index = 0  # Default index in the array of account names
user_accounts = ['real-account']  # Brownie encrypted account names


# Test Wallets
# Generated from https://vanity-eth.tk/
test_wallets = [
    '0xD0583e2195E866d9E773C4Ef6Ba21BdDa3732b7B',
    '0x7eC0BfD42eA25f3826668C0574249D8e87cceB38',
    '0x509f3d0D9abCDc94F3189E35322F7D655e0872e1',
    '0xB5318747A65398f8EEcB303805f3176D7e0F5291'
]


# Blockchains
local_BSC = 'bsc-fork'  # A fork from the BSC Mainnet
test_BSC = 'bsc-test'  # BSC Testnet
main_BSC = 'bsc-main'  # BSC Mainnet


# Active Network
# Auto PancakeSwap Router (Mainnet & Mainnet-Fork OR Testnet)
pancake_mainnet = '0x10ED43C718714eb63d5aA57B78B54704E256024E'
pancake_testnet = '0xd99d1c33f9fc3444f8101754abc46c52416550d1'
active_network = network.show_active()
if (active_network == local_BSC or active_network == main_BSC):
    pancake_router = pancake_mainnet
elif (active_network == test_BSC):
    pancake_router = pancake_testnet
