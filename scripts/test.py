from scripts.utils.brownie_connect import getAccount
from scripts.utils.pyprint import pyprint
from scripts.utils.generators import generateAddressArray
import scripts.settings as settings
from brownie import Ostra


# RANDOM ACCOUNT ADDRESSES
ACCOUNTS = [
    '0x8125b7cB77952688c84A129c401f065FaEc8DD24',
    '0xd6Eeb7216a30F9941BC4C584B988aA5550BbB78C',
    '0x49f18D513Dc0db27c1E643c92A56ab589B39E7b1',
    '0xe118193c8F8f5d7D8fEd36962285424BE1786bb2',
    '0x464F53eF36B068c399e859aF6231810A6ef94Ee0'
]


# INITIALIZE CONTRACT
account = getAccount()
txFrom = {'from': account}
contract = Ostra[-1]  # Get Last Contract


def main():
    pass