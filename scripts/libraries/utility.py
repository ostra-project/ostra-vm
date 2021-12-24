from pathlib import Path
from colorama import Style, Fore
from brownie import (accounts, config)
import sys, os, random, json


current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


# PYPRINT
currentSectionTitle = ''
def pyprint(msg = 'Null', title = None, percents = None, sectionTitle = settings.pyprintTitle):
    global currentSectionTitle
    if currentSectionTitle != sectionTitle:
        print('')
        print(f'{settings.pyprintColor}-------------- {sectionTitle} --------------{Style.RESET_ALL}')
        currentSectionTitle = sectionTitle

    output = str(msg)
    outputInt = 0

    if output.isdecimal():
        outputInt = int(output)
        outputInt = outputInt / settings.contractDecimals
        output = f'{outputInt:,}'

    output = f'{settings.pyprintColor}{output}{Style.RESET_ALL}'

    outPercents = ''
    if percents != None:
        outPercents = f'({settings.pyprintColor}{round(percents, settings.pyprintRounding)}%{Style.RESET_ALL})'

    if title != None:
        print('==>', title + ':', output, outPercents)
    else:
        print('==>', output, outPercents)



# Brownie Connect
# settings.userAccount contains the names of yout Brownie saved accounts
# settings.defAccountIndex corresponds to the default account index
accountID = settings.userAccount[settings.defAccountIndex]
def getAccount(index = 0, ID = accountID):

    # Local BSC Fork
    if settings.activeNetwork == settings.localBSC:
        return accounts[index]

    # Testnet
    if settings.activeNetwork == settings.testBSC:
        return accounts.add(config['wallets']['from_key'])

    # Mainnet
    if ID and settings.activeNetwork == settings.mainBSC:
        return accounts.load(ID)



# Address Array Generator
# Generate random account addresses for a Smart Contract stress-test
# /!\ This is a PRNG. It SHOULD never be used on a public blockchain.
# https://en.wikipedia.org/wiki/Pseudorandom_number_generator
# letterStrength corresponds to the rarity of the letters
# in the generated address
def generateAddressArray(nbLoop, letterStrength = 4):
    addresses = []

    for _ in range(0, nbLoop):
        address = ''
        for _ in range(0, 40):
            seedTest = random.randrange(0, letterStrength)
            if (seedTest == 0):
                seed = random.randrange(0, 6)
                char = chr(97 + seed)
            else:
                seed = random.randrange(0, 10)
                char = str(seed)
            
            address += char

        addresses.append('0x' + address)
    
    return addresses



# Get the size of a contract
# The path used to find the compiled JSON contract is ../build/contracts/
# As contract_size.py is, by default inside the scripts/utils folder,
def getContractSize():
    contractName = settings.contractName + '.json'
    relativePath = settings.contractFolder + contractName

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
