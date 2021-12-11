from scripts.contract_size import getContractSize
from scripts.lib import (
    pyprint,
    getAccount,
    PANCAKESWAP_ROUTER
)
from brownie import (
    config,
    network,
    Ostra
)


def deploy():

    account = getAccount()
    txFrom = {'from': account}
    
    contract = Ostra.deploy(
        account.address,
        PANCAKESWAP_ROUTER,
        txFrom,
        publish_source = config['networks'][network.show_active()].get('verify', False)
    )

    pyprint(f'{contract.address}', 'Contract Address')
    return contract


def main():
    getContractSize()
    deploy()
