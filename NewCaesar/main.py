import string

start = "dcebcmebecamcmanaedbacdaanafagapdaaoabaaafdbapdpaaapadanandcafaadbdaapdpandcac"

ALPHABET = string.ascii_lowercase[:16]

def run(flag):
    """Convert b16_encoded strings to ascii
    
    Converts characters to binary, 
    Joins n and n+1 binary representation
    Converts the joined string into ascii

    Finally joins all converted ASCII strings
    """
    binary = ['{:04b}'.format(ALPHABET.index(ch)) for ch in flag]
    chars = [chr(int(''.join(binary[i:i+2]), 2)) for i in range(0, len(binary), 2)]
    return ''.join(chars)

def unshift(v, k):
    """Unshifts characters"""
    LOWERCASE_OFFSET = ord('a')
    v1 = ord(v) - LOWERCASE_OFFSET # current shifted position
    t2 = ord(k) - LOWERCASE_OFFSET # shift value
    diff = v1 - t2
    
    pos = diff if diff >= 0 else diff + len(ALPHABET)
    return ALPHABET[pos]

for alphabet in ALPHABET:
    flag = ''.join([unshift(s, alphabet) for s in start])
    print('key: ' + alphabet, 'flag: ' + run(flag), 'len: ' + str(len(flag)))


