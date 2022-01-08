from brownie import (config, Ostra)
import settings
from libraries.utility import *


# Default Contract Vars
account = get_account()
tx_from = {'from': account}


def deploy():
    contract = Ostra.deploy(tx_from)
    return contract


def main():
    get_contract_size()
    deploy()
