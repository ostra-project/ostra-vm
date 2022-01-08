from scripts.libraries.utility import *
from brownie import Ostra
import scripts.settings as settings


# Default Contract Vars
account = get_account()
tx_from = {'from': account}
contract = Ostra[-1]  # Get Last Contract


def main():
    DRV.pyprint(contract.getRes(), 'First Result')
    contract.add(gwei(150), gwei(150), tx_from)
    DRV.pyprint(contract.getRes(), 'Second Result')
