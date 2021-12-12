import sys, os, json
from pathlib import Path

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


def getContractSize():
    print('')
    print('-------------- CONTRACT SIZE --------------')

    contractName = settings.contractName + '.json'
    relativePath = f'../build/contracts/{contractName}'

    bytecodeSize = 0
    cwd = Path(__file__).parent.parent
    contractPath = (cwd / relativePath).resolve()

    try:
        contract = open(contractPath)
        data = json.load(contract)

        if 'deployedBytecode' not in data:
            print(f'==> ERROR: deployedBytecode not found in {relativePath}')
        else:
            hexBytecode = bytes.fromhex(data['deployedBytecode'])
            bytecodeSize = len(hexBytecode) * 2
            sizePercentage = round((bytecodeSize / settings.contractSizeLimit) * 100, 2)

            if sizePercentage <= 100:
                print('==> Percentage Used:', f'{sizePercentage}%')
            else:
                print(f'==> ERROR: SIZE LIMIT IS REACHED')

            print('==> Contract Size:', f'{bytecodeSize}/{settings.contractSizeLimit} bytes')

    except OSError:
        print('==> ERROR: Can\'t get contract file from the build directory')

    return bytecodeSize
