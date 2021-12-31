import scripts.settings as settings
from scripts.libraries.utility import (
    getContractSize,
    getAccount,
    pyprint
)
from brownie import (
    Ostra
)



# Default Contract Vars
account = getAccount()
txFrom = {'from': account}


def deploy():
    contract = Ostra.deploy(txFrom)
    return contract


def main():
    getContractSize()
    deploy()
