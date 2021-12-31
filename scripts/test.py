import scripts.settings as settings
from scripts.libraries.utility import (
    getAccount,
    pyprint,
    gwei
)
from brownie import (
    Ostra
)


# Default Contract Vars
account = getAccount()
txFrom = {'from': account}
contract = Ostra[-1]  # Get Last Contract


def main():
    pyprint(contract.getRes(), 'First Result')
    contract.add(gwei(150), gwei(150), txFrom)
    pyprint(contract.getRes(), 'Second Result')
