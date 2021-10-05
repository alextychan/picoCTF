from pwn import *

# The encrypted flag is XOR'ed with a key
# The key is read from a file of size 50000
# The length of the flag, is 32. 
# - Encrypted flag is just a concatenation of left padded hex strings of size 2 each
# Solution:
# - Cause a wrap around and then use the function to XOR the encrypted flag again to decode it
# - Hint: Inverse of an XOR is an XOR. a = b ^ c; b = a ^ c

KEY_LEN = 50000
MAX_CHUNK = 1000

r = remote("mercury.picoctf.net", 36981)
r.recvuntil("This is the encrypted flag!\n")
flag = r.recvlineS(keepends = False)
log.info(f"Flag: {flag}")
bin_flag = unhex(flag)

counter = KEY_LEN - len(bin_flag)

with log.progress('Causing wrap-around') as p:
    while counter > 0:
        p.status(f"{counter} bytes left")
        chunk_size = min(MAX_CHUNK, counter)
        r.sendlineafter("What data would you like to encrypt? ", "a" * chunk_size)
        
        counter -= chunk_size

r.sendlineafter("What data would you like to encrypt? ", bin_flag)
r.recvlineS()
log.success("The flag: {}".format(unhex(r.recvlineS())))