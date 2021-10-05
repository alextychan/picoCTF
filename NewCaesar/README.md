New Caesar Cryptography

# Solution

Reverse the encoded flag.



The given flag has been b16_encoded and shifted with an unknown. Let's undo the shifting.

The function below will unshift the characters given both a character and key as input
```python
def unshift(v, k):
    """Unshifts characters"""
    LOWERCASE_OFFSET = ord('a')
    v1 = ord(v) - LOWERCASE_OFFSET # current shifted position
    t2 = ord(k) - LOWERCASE_OFFSET # shift value
    diff = v1 - t2
    
    pos = diff if diff >= 0 else diff + len(ALPHABET)
    return ALPHABET[pos]
```

After shifting back into position, we need to convert it back to ASCII
```python
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
```

Before we continue, let's take a look at some crucial hints.

Hint 1: Key must be in the first 16 lowercase alphabets.
```python
assert all([k in ALPHABET for k in key])
```

Hint 2: Key is of length 1
```python
assert len(key) == 1
```

As we are not given the flag, all we have to do is brute force it. (Since there's only 16 possibilities).

```python
for alphabet in ALPHABET:
    flag = ''.join([unshift(s, alphabet) for s in start])
    print('key: ' + alphabet, 'flag: ' + run(flag), 'len: ' + str(len(flag)))
```

Then finally we plug the output into new_caesar.py.

Flag: `et_tu?_07d5c0892c1438d2b32600e83dc2b0e5`, key: `n`