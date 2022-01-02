from brownie import Ostra
import scripts.settings as settings
from scripts.libraries.utility import (
    get_contract_size,
    get_account,
    gwei,
    pyprint
)



# Default Contract Vars
account = get_account()
tx_from = {'from': account}
contract = Ostra[-1]  # Get Last Contract


def main():
    pyprint(contract.getRes(), 'First Result')
    contract.add(gwei(150), gwei(150), tx_from)
    pyprint(contract.getRes(), 'Second Result')
