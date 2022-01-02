from brownie import (config, Ostra)
import scripts.settings as settings
from scripts.libraries.utility import (
    get_contract_size,
    get_account,
    pyprint
)



# Default Contract Vars
account = get_account()
tx_from = {'from': account}


def deploy():
    contract = Ostra.deploy(tx_from)
    return contract


def main():
    get_contract_size()
    deploy()
