import base64
import json
import grequests
import string
import sys

def flip_bit(input, pos, bit): 
    decoded = base64.b64decode(input)
    flipped = decoded[pos] ^ bit
    transformed = decoded[:pos] + int.to_bytes(flipped, 1, byteorder='little') + decoded[pos+1:]
    return base64.b64encode(transformed).decode('utf-8')

cookie = "WE1wM2MwaUE2K2syTW5Ndlp1VVg4T0xQV1lxTkZlQ0NVOWI4YS9xTStkQ0RjUkRUYUxGYjdPeVZKZ3ZiUFpjZjArZ0l0aHJFTHVzK2hzNmdmZUlRUzMwQjZzbEJxZHUwZm4wODNQdzV2WGRoZ2ZlVnYxaVJINWxhQW9SVWhHRVE="

for pos in range(len(cookie)):    
    reqs = []
    for i, val in enumerate(string.printable):
        transformed = flip_bit(cookie, pos, ord(val))
        req = grequests.get("http://mercury.picoctf.net:34962/", cookies={ 'auth_name': transformed, 'name': '0' })
        reqs.append(req)
    resps = grequests.map(reqs, size=10)
    for resp in resps:
        if "pico" in resp.text:
            print(json.dumps(resp.request.headers["Cookie"]))
            print(resp.text)
            sys.exit()
