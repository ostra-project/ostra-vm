from colorama import Style
import sys, os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)
import settings


currentSectionTitle = ''
def pyprintInit(sectionTitle):
    global currentSectionTitle
    if currentSectionTitle != sectionTitle:
        print('')
        print(f'{settings.pyprintColor}-------------- {sectionTitle} --------------{Style.RESET_ALL}')
        currentSectionTitle = sectionTitle


def pyprint(msg = 'Null', title = None, percents = None, sectionTitle = settings.pyprintTitle):
    pyprintInit(sectionTitle)

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
