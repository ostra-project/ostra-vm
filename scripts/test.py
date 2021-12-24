from brownie import Ostra
import scripts.settings as settings
from scripts.libraries.utility import (
    generateAddressArray,
    getContractSize,
    getAccount,
    pyprint
)


# Default Contract Vars
account = getAccount()
txFrom = {'from': account}
contract = Ostra[-1]  # Get Last Contract


def main():
    pass