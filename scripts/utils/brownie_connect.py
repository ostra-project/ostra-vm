from brownie import (accounts, config)
import sys, os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


# Get Account depending of the current active network
accountID = settings.mainAccount[settings.defAccountIndex]
def getAccount(index = None, ID = accountID):
    if index:
        return accounts[index]
    
    if ID and settings.activeNetwork in settings.mainEnv:
        return accounts.load(ID)

    if settings.activeNetwork in settings.localEnv:
        return accounts[0]

    return accounts.add(config['wallets']['from_key'])
