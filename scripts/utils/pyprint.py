from colorama import Fore, Style
import sys, os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


initPyprint = False
def pyprintInit():
    global initPyprint
    if not initPyprint:
        print('')
        print(f'{settings.pyprintColor}-------------- DEBUG ZONE --------------{Style.RESET_ALL}')
        initPyprint = True


def pyprint(msg = 'Null', title = None, percents = None):
    pyprintInit()

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
