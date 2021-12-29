import scripts.settings as settings
from scripts.libraries.utility import (
    getContractSize,
    getAccount,
    pyprint
)
from brownie import (
    config,
    Ostra,
    xUpdateModule,
    xModuleExplorer,
    InitOstra
)


# Default Contract Vars
account = getAccount()
txFrom = {'from': account}


def deploy():
    updateModule = xUpdateModule.deploy(txFrom)
    contract = Ostra.deploy(updateModule.address, txFrom)
    initContract = InitOstra.deploy(txFrom)

    pyprint(updateModule.address, 'Update Module Contract Deployed')
    pyprint(contract.address, 'Main Contract Deployed')
    pyprint(initContract.address, 'Init Contract Deployed')
    print('')

    # Deploy Modules
    moduleNames = [xModuleExplorer]
    moduleLen = len(moduleNames)
    moduleList = []

    for i in range (0, moduleLen):
        currentModule = moduleNames[i].deploy(txFrom)
        moduleList.append({
            'modAddress': currentModule.address,
            'funcSelectors': 0,
            'UpdateMethod': 'ADD'
        })

        pyprint(currentModule.address, 'Module Deployed')


def main():
    getContractSize()
    deploy()


# contract = Ostra.deploy(
#     account.address,
#     settings.pancakeRouter,
#     txFrom,
#     publish_source = config['networks'][settings.activeNetwork].get('verify', False)
# )

# return contract