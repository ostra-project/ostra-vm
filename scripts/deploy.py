from brownie import (config, Ostra)
import scripts.settings as settings
from scripts.libraries.utility import (
    getContractSize,
    getAccount,
    pyprint
)


# Default Contract Vars
account = getAccount()
txFrom = {'from': account}


def deploy():
    contract = Ostra.deploy(
        account.address,
        settings.pancakeRouter,
        txFrom,
        publish_source = config['networks'][settings.activeNetwork].get('verify', False)
    )

    return contract


def main():
    getContractSize()
    deploy()
