from scripts.lib import pyprint, getAccount
from brownie import Ostra


def gwei(amount):
    return amount * 10**8


def interact():
    account = getAccount()
    txFrom = {'from': account}
    contract = Ostra[-1]  # Get Last Contract


def main():
    interact()
