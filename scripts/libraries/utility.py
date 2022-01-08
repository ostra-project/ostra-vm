# Ganache UI App should be launched to use the get_account() function
from brownie import accounts, config
from colorama import Fore, Style
from .statics import Statics
from pathlib import Path
import scripts.settings as settings
import random
import json


class DRV:
    SECTION_TITLE: str = ''

    @staticmethod
    def pyprint(msg: str = 'Null',
        title = None,
        percents: int = None,
        section_title: str = settings.pyprint_title
    ):
        '''Allows the user to print into the console with the Brownie Colorama / Style

        Args:
            msg: Logging message.
            title: Logging title.
            percents: Percents (Wallet / TotalSupply).
            section_title: Title of the section.
        '''
        
        separators = '-' * 24
        if DRV.SECTION_TITLE != section_title:
            print('')
            print(f'\n{settings.pyprint_color}{separators} {section_title} {separators}{Style.RESET_ALL}')
            DRV.SECTION_TITLE = section_title

        output = str(msg)

        if output.isdecimal():
            output_int = int(output)
            output_int = output_int / settings.contract_decimals
            output = f'{output_int:,}'

        output = f'{settings.pyprint_color}{output} {Style.RESET_ALL}'

        out_percents = ''
        if percents is not None:
            out_percents = f'({settings.pyprint_color}{round(percents, settings.pyprint_rounding)}%{Style.RESET_ALL})'

        if title is not None:
            print(f'> {title}: {output} {out_percents}')
        else:
            print(f'> {output}, {out_percents}')


def get_account(index: int = 0, ID: str = Statics.ACCOUNT_DEF_ID):
    '''Get user account depending on the current used network

    Args:
        index: Default index of test accounts
        ID: Identifier of the account.
        
    Returns:
        ***: Account var
    '''
    
    # Local BSC Fork
    if settings.active_network == settings.local_BSC:
        return accounts[index]

    # Testnet
    if settings.active_network == settings.test_BSC:
        return accounts.add(config['wallets']['from_key'])

    # Mainnet
    if ID and settings.active_network == settings.main_BSC:
        return accounts.load(ID)


class AddressGenerator:
    '''Address Array Generator
    Generate random account addresses for a Smart Contract stress-test
    /!\ This is a PRNG. It SHOULD never be used on a public blockchain.
    https://en.wikipedia.org/wiki/Pseudorandom_number_generator
    letterStrength corresponds to the rarity of the letters
    in the generated address
    '''
    @staticmethod
    def char_gen(letter_strength: int) -> str:
        seed_test = random.randrange(0, letter_strength)
        if seed_test == 0:
            seed = random.randrange(0, 6)
            return chr(97 + seed)
        else:
            seed = random.randrange(0, 10)
            return str(seed)
    
    @staticmethod
    def generate_address(letter_strength: int) -> str:
        address_end: str = ''.join([
            AddressGenerator.char_gen(letter_strength)
            for _ in range(0, 40)
        ])
        return f'0x{address_end}'
    
    @staticmethod
    def generate_n_addresses(n: int, letter_strength: int = 4) -> list[str]:
        return [
            AddressGenerator.generate_address(letter_strength)
            for _ in range(0, n)
        ]


def get_compiled_code(section_title: str) -> dict:
    '''Get the compiled code data from the build/contracts folder
    This bytecode is found after the key 'deployedBytecode'
    Inside the main contract .json file, the name can be modifier
    Inside the 'settings.py' file
    '''
    contract_name = f'{settings.contract_name}.json'
    relative_path = settings.contract_folder + contract_name

    data = None
    cwd = Path(__file__).parent.parent
    contract_path = (cwd / relative_path).resolve()

    try:
        with open(contract_path) as contract:
            data = json.load(contract)
    except OSError:
        DRV.pyprint('Can\'t get contract file from the build directory', 'ERROR', None, section_title)

    return data


def get_contract_size() -> int:
    '''Get the size of a contract
    The path used to find the compiled JSON contract is ../build/contracts/
    As contract_size.py is, by default inside the scripts/utils folder,

    Returns:
        int: Size of the deployed bytecode.
    '''

    section_title = 'CONTRACT SIZE'
    data = get_compiled_code(section_title)
    bytecode_size = 0

    if data is not None:
        if 'deployedBytecode' not in data:
            DRV.pyprint(f'deployedBytecode not found in {settings.contract_folder}', 'ERROR', None, section_title)
        else:
            hex_bytecode = bytes.fromhex(data['deployedBytecode'])
            bytecode_size = len(hex_bytecode) * 2
            size_percentage = round((bytecode_size / settings.contract_size_limit) * 100, 2)
            
            msg, title = (
                (f'{size_percentage}%', 'Percentage used')
                if size_percentage <= 100 else
                ('SIZE LIMIT IS REACHED', 'ERROR')
            )

            DRV.pyprint(msg, title, None, section_title)
            DRV.pyprint(f'{bytecode_size} / {settings.contract_size_limit} bytes', 'Contract Size', None, section_title)

    print('')
    return bytecode_size


# Get the TX Hash from a TransactionReceipt object
def get_TX_hash(tx):
    txHash = str(tx)
    return txHash[14:-2]


# Converts basic values to uint256 decimals
def gwei(number):
    return number * 10**8
