from brownie import (accounts, config)
import sys, os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


# Get Account depending of the current active network
accountID = settings.mainAccount[settings.defAccountIndex]
def getAccount(index = 0, ID = accountID):

    # Local BSC Fork
    if settings.activeNetwork == settings.localBSC:
        return accounts[index]

    # Testnet
    if settings.activeNetwork == settings.testBSC:
        return accounts.add(config['wallets']['from_key'])

    # Mainnet
    if ID and settings.activeNetwork == settings.mainBSC:
        return accounts.load(ID)
