# Generate random account addresses for a Smart Contract stress-test
# /!\ This is a PRNG. It SHOULD never be used on a public blockchain.
# https://en.wikipedia.org/wiki/Pseudorandom_number_generator


import random


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
