from colorama import Fore, Style
from brownie import (
    accounts,
    network,
    config
)


# https://eth-brownie.readthedocs.io/en/stable/account-management.html
MAIN_ACCOUNTS = ['ACCOUNT_NAME']
# https://eth-brownie.readthedocs.io/en/stable/network-management.html
LOCAL_ENVIRONMENTS = ["bsc-fork"]
MAIN_ENVIRONMENTS = ["bsc-main"]  # (Already in Brownie)

# Contract Decimals
DECIMALS = 10**8

# Auto PancakeSwap Router (Mainnet & Mainnet Fork OR Testnet)
activeNetwork = network.show_active()
if activeNetwork in LOCAL_ENVIRONMENTS or activeNetwork in MAIN_ENVIRONMENTS:
    PANCAKESWAP_ROUTER = '0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F'
else:
    PANCAKESWAP_ROUTER = '0xD99D1c33F9fC3444f8101754aBC46c52416550D1'


# Pyprint (Now Supports Colors that matches Brownie colors)
pyprintColor = Fore.LIGHTBLUE_EX
initPyprint = False
def pyprintInit():
    global initPyprint
    if not initPyprint:
        print('')
        print(f'{pyprintColor}-------------- DEBUG ZONE --------------{Style.RESET_ALL}')
        initPyprint = True


def pyprint(msg = 'Null', title = None, percents = None):
    pyprintInit()

    output = str(msg)
    outputInt = 0

    if output.isdecimal():
        outputInt = int(output)
        outputInt = outputInt / DECIMALS
        output = f'{outputInt:,}'

    output = f'{pyprintColor}{output}{Style.RESET_ALL}'

    outPercents = ''
    if percents != None:
        outPercents = f'({pyprintColor}{round(percents, 4)}%{Style.RESET_ALL})'
    

    if title != None:
        print('==>', title + ':', output, outPercents)
    else:
        print('==>', output, outPercents)


# Get Account depending of the current active network
def getAccount(index = None, ID = MAIN_ACCOUNTS[0]):
    # accounts[0]  -> AUTO-GENERATED LOCAL
    # accounts.add("env")  -> MAINNET WITHOUT REAL ASSETS
    # accounts.load("id")  -> MAINNET REAL ACCOUNT

    if index:
        return accounts[index]
    
    if ID and activeNetwork in MAIN_ENVIRONMENTS:
        return accounts.load(ID)

    if activeNetwork in LOCAL_ENVIRONMENTS:
        return accounts[0]

    return accounts.add(config['wallets']['from_key'])
