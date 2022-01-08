from brownie import Ostra
import settings
from libraries.utility import *


# Default Contract Vars
account = get_account()
tx_from = {'from': account}
contract = Ostra[-1]  # Get Last Contract


def main():
    DRV.pyprint(contract.getRes(), 'First Result')
    contract.add(gwei(150), gwei(150), tx_from)
    DRV.pyprint(contract.getRes(), 'Second Result')
