import scripts.settings as settings
from scripts.libraries.utility import (
    UpdateMethod,
    getContractSize,
    modGetSelectors,
    getAccount,
    getTxHash,
    pyprint
)

from brownie import (
    Ostra,
    ModUpdate,
    ModExplorer,
    InitOstra
)


# Default Contract Vars
account = getAccount()
txFrom = {'from': account}


def deploy():
    updateModule = ModUpdate.deploy(txFrom)
    contract = Ostra.deploy(updateModule.address, txFrom)
    initContract = InitOstra.deploy(txFrom)

    # Deploy Modules
    moduleNames = [ModExplorer]
    moduleLen = len(moduleNames)
    moduleList = []

    for i in range (0, moduleLen):
        currentModule = moduleNames[i].deploy(txFrom)
        moduleList.append([
            currentModule.address,
            modGetSelectors(currentModule),
            UpdateMethod['ADD']
        ])

    functionCall = initContract.signatures['init']
    tx = updateModule.updateModule(moduleList, initContract.address, functionCall)

    pyprint(updateModule.address, 'UpdateModule Contract Deployed')
    pyprint(contract.address, 'Main Contract Deployed')
    pyprint(initContract.address, 'Init Contract Deployed')

    if not tx.revert_msg:
        pyprint(getTxHash(tx), 'Update Module Completed')
    else:
        pyprint(tx.revert_msg, 'ERROR')


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