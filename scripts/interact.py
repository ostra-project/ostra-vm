from scripts.utils.brownie_connect import getAccount
from scripts.utils.pyprint import pyprint
from scripts.utils.generators import generateAddressArray
import scripts.settings as settings
from brownie import Diamond


def gwei(amount):
    return amount * settings.contractDecimals


def interact():
    account = getAccount()
    txFrom = {'from': account}
    contract = Diamond[-1]  # Get Last Contract


def main():
    interact()
