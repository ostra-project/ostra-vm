# Ganache UI App should be launched to use the getAccount() function


from pathlib import Path
from colorama import Style, Fore
from brownie import (accounts, config)
import sys, os, random, json


current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


# Pyprint
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


# Get the compiled code data from the build/contracts folder
# This bytecode is found after the key 'deployedBytecode'
# Inside the main contract .json file, the name can be modifier
# Inside the 'settings.py' file
def getCompiledCode(sectionTitle):
    contractName = settings.contractName + '.json'
    relativePath = settings.contractFolder + contractName

    data = None
    cwd = Path(__file__).parent.parent
    contractPath = (cwd / relativePath).resolve()

    try:
        contract = open(contractPath)
        data = json.load(contract)
        contract.close()
    except OSError:
        pyprint('Can\'t get contract file from the build directory', 'ERROR', None, sectionTitle)

    return data


# Get the size of a contract
# The path used to find the compiled JSON contract is ../build/contracts/
# As contract_size.py is, by default inside the scripts/utils folder,
def getContractSize():

    sectionTitle = 'CONTRACT SIZE'
    data = getCompiledCode(sectionTitle)
    bytecodeSize = 0

    if data != None:
        if 'deployedBytecode' not in data:
            pyprint(f'deployedBytecode not found in {settings.contractFolder}', 'ERROR', None, sectionTitle)
        else:
            hexBytecode = bytes.fromhex(data['deployedBytecode'])
            bytecodeSize = len(hexBytecode) * 2
            sizePercentage = round((bytecodeSize / settings.contractSizeLimit) * 100, 2)

            if sizePercentage <= 100:
                pyprint(f'{sizePercentage}%', 'Percentage used', None, sectionTitle)
            else:
                pyprint('SIZE LIMIT IS REACHED', 'ERROR', None, sectionTitle)

            pyprint(f'{bytecodeSize} / {settings.contractSizeLimit} bytes', 'Contract Size', None, sectionTitle)

    print('')
    return bytecodeSize


# Diamond (Modules System)
UpdateMethod = {'ADD': 0, 'REPLACE': 1, 'REMOVE': 2}


def modGetSelectors(contract):
    pass


def modGetSelector(func):
    pass


def modRemove(functionNames):
    pass


def modGet(functionNames):
    pass


def modRemoveSelectors(selectors, signatures):
    pass


def modFindAddressPosInModule(moduleAddress, modules):
    pass
