# Made by Yoratoni (https://github.com/yoratoni)
# Check the last compiled Smart Contract size (Limited to 24576 bytes)

# This script will get the deployed Bytecode directly from the build folder
    # 1- Use the command 'brownie compile'
    # 2- 'python scripts/tests/contract_size.py' / 'brownie run scripts/interact.py'


from pathlib import Path
import json


CONTRACT_NAME = 'Matrix.json'
CONTRACT_LIMIT_SIZE = 24 * 1024
RELATIVE_PATH = f'../build/contracts/{CONTRACT_NAME}'


def getContractSize(name = CONTRACT_NAME):
    if name != CONTRACT_NAME:
        name += '.json'
    
    print('')
    print('******* CONTRACT SIZE *******')

    bytecodeSize = 0
    cwd = Path(__file__).parent  # __relative_path__/scripts
    contractPath = (cwd / RELATIVE_PATH).resolve()  # __cwd__/build/contracts/contract_name.json

    try:
        contract = open(contractPath)
        data = json.load(contract)

        if 'deployedBytecode' not in data:
            print(f'==> ERROR: deployedBytecode not found in {RELATIVE_PATH}')
        else:
            hexBytecode = bytes.fromhex(data['deployedBytecode'])
            bytecodeSize = len(hexBytecode) * 2
            sizePercentage = round((bytecodeSize / CONTRACT_LIMIT_SIZE) * 100, 2)

            if sizePercentage <= 100:
                print('==> Percentage Used:', f'{sizePercentage}%')
            else:
                print(f'==> ERROR: SIZE LIMIT IS REACHED')

            print('==> Contract Size:', f'{bytecodeSize}/{CONTRACT_LIMIT_SIZE} bytes')

    except OSError:
        print('==> ERROR: Can\'t get contract file from the build directory')

    return bytecodeSize
