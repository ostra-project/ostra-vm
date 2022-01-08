from scripts.libraries.utility import *
from brownie import (config, Ostra)
import scripts.settings as settings


# Default Contract Vars
account = get_account()
tx_from = {'from': account}


def deploy():
    contract = Ostra.deploy(tx_from)
    return contract


def main():
    get_contract_size()
    deploy()
