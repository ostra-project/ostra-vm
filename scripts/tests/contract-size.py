# Made by Yoratoni (https://github.com/yoratoni)
# Check the last compiled Smart Contract size (Limited to 24576 bytes)

# This script will get the deployed Bytecode directly from the build folder
    # 1- Use the command 'brownie compile'
    # 2- Use the command 'python scripts/tests/contract-size.py'


from pathlib import Path
import json


CONTRACT_NAME = 'Ostra.json'
CONTRACT_SIZE = 24 * 1024
RELATIVE_PATH = f'../build/contracts/{CONTRACT_NAME}'


print('')
print('******* CONTRACT SIZE *******')


cwd = Path(__file__).parent.parent  # __relative_path__/scripts
contractPath = (cwd / RELATIVE_PATH).resolve()  # __cwd__/build/contracts/contract_name.json


try:
    contract = open(contractPath)
    data = json.load(contract)

    if 'deployedBytecode' not in data:
        print(f'==> ERROR: deployedBytecode not found in {RELATIVE_PATH}')
    else:
        hexBytecode = bytes.fromhex(data['deployedBytecode'])
        bytecodeSize = len(hexBytecode) * 2
        sizePercentage = round((bytecodeSize / CONTRACT_SIZE) * 100, 2)

        print('==> Contract Size:', f'{bytecodeSize}/{CONTRACT_SIZE} bytes')
        print('==> Percentage Used:', f'{sizePercentage}%')

except OSError:
    print('==> ERROR: Can\'t get contract file from the build directory')
