from scripts.utils.contract_size import getContractSize
from scripts.utils.brownie_connect import getAccount
from scripts.utils.pyprint import pyprint
import scripts.settings as settings
from brownie import (config, OSTRA)


def deploy():
    account = getAccount()
    txFrom = {'from': account}
    
    contract = OSTRA.deploy(
        account.address,
        settings.pancakeRouter,
        txFrom,
        publish_source = config['networks'][settings.activeNetwork].get('verify', False)
    )

    return contract


def main():
    getContractSize()
    deploy()
