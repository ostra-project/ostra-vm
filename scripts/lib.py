from brownie import (
    accounts,
    network,
    config
)
import brownie


MAIN_ENVIRONMENTS = ["bsc-fork", "bsc-main"]

if network.show_active() in MAIN_ENVIRONMENTS:
    PANCAKESWAP_ROUTER = '0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F'
else:
    PANCAKESWAP_ROUTER = '0xD99D1c33F9fC3444f8101754aBC46c52416550D1'


DECIMALS = 10**8


init_pyprint = False
def pyprintInit():
    global init_pyprint
    if not init_pyprint:
        print('')
        print('******* DEBUG ZONE *******')
        init_pyprint = True


def pyprint(msg = 'Null', title = None):
    pyprintInit()

    output = str(msg)
    outputInt = 0

    if output.isdecimal():
        outputInt = int(output)
        outputInt = outputInt / DECIMALS
        output = f'{outputInt:,}'

    if title != None:
        print('==>', title + ':', output)
    else:
        print('==>', output)


def getAccount(index = None, ID = None):
    # accounts[0]  -> AUTO-GENERATED LOCAL
    # accounts.add("env")  -> MAINNET WITHOUT REAL ASSETS
    # accounts.load("id")  -> MAINNET REAL ACCOUNT

    if index:
        return accounts[index]
    
    if ID:
        return accounts.load(ID)

    if network.show_active() in MAIN_ENVIRONMENTS:
        return accounts[0]

    return accounts.add(config['wallets']['from_key'])
