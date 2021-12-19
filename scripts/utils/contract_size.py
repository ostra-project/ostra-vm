import sys, os, json
from pathlib import Path
from utils.pyprint import pyprint

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


def getContractSize():
    contractName = settings.contractName + '.json'
    relativePath = f'../build/contracts/{contractName}'

    bytecodeSize = 0
    cwd = Path(__file__).parent.parent
    contractPath = (cwd / relativePath).resolve()

    try:
        contract = open(contractPath)
        data = json.load(contract)

        if 'deployedBytecode' not in data:
            pyprint(f'deployedBytecode not found in {relativePath}', 'ERROR', None, 'CONTRACT SIZE')
        else:
            hexBytecode = bytes.fromhex(data['deployedBytecode'])
            bytecodeSize = len(hexBytecode) * 2
            sizePercentage = round((bytecodeSize / settings.contractSizeLimit) * 100, 2)

            if sizePercentage <= 100:
                pyprint(f'{sizePercentage}%', 'Percentage used', None, 'CONTRACT SIZE')
            else:
                pyprint('SIZE LIMIT IS REACHED', 'ERROR', None, 'CONTRACT SIZE')

            pyprint(f'{bytecodeSize} / {settings.contractSizeLimit} bytes', 'Contract Size', None, 'CONTRACT SIZE')

    except OSError:
        pyprint('Can\'t get contract file from the build directory', 'ERROR', None, 'CONTRACT SIZE')

    return bytecodeSize
