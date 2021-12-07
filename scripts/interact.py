from scripts.lib import pyprint, getAccount
from brownie import Ostra


def setGwei(amount):
    return amount * 10**8


def burn(contract, txFrom, txBurn):
    contract.burn(txBurn, txFrom)
    printBurn = contract.totalBurn()
    printTotalSupply = contract.totalSupply()

    pyprint(txBurn, 'Expected Burn')
    pyprint(printBurn, 'Burn')
    pyprint(printTotalSupply, 'Total Supply')


def transfer(contract, account, address, amount):
    txFrom = {'from': account}
    contract.transfer(address, amount, txFrom)
    printBalanceFrom = contract.balanceOf(account.address)
    printBalanceTo = contract.balanceOf(address)

    pyprint(printBalanceFrom, 'Sender Balance')
    pyprint(printBalanceTo, 'Receiver Balance')


def interact():
    account = getAccount()
    txFrom = {'from': account}
    contract = Ostra[-1]  # Get Last Contract
    
    burn(contract, txFrom, setGwei(100))


def main():
    interact()
