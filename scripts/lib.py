from brownie import (
    accounts,
    network,
    config
)


MAIN_ENVIRONMENTS = ["bsc-fork"]
PANCAKESWAP_ROUTER = '0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F'


init_pyprint = False
def pyprintInit():
    global init_pyprint
    if not init_pyprint:
        print('')
        print('******* DEBUG ZONE *******')
        init_pyprint = True


def pyprint(msg = 'Null', title = None):
    pyprintInit()
    if title != None:
        print('==>', title + ':', msg)
    else:
        print('==>', msg)



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
