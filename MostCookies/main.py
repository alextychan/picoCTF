import base64
import json as _json
from datetime import datetime
from hashlib import sha1 as _default_hash
from hmac import new as hmac
from numbers import Number
from time import time
import sys

_default_encoding = sys.getdefaultencoding()
hash_method = _default_hash

def to_bytes(x, charset=_default_encoding, errors="strict"):
    if x is None:
        return None

    if isinstance(x, (bytes, bytearray, memoryview)):
        return bytes(x)

    if isinstance(x, str):
        return x.encode(charset, errors)

    raise TypeError("Expected bytes")


def to_native(x, charset=_default_encoding, errors="strict"):
    if x is None or isinstance(x, str):
        return x

    return x.decode(charset, errors)

def serialize(data, secret_key, expires=None):
    """Serialize the secure cookie into a string.
    If expires is provided, the session will be automatically
    invalidated after expiration when you unserialize it. This
    provides better protection against session cookie theft.
    :param expires: An optional expiration date for the cookie (a
        :class:`datetime.datetime` object).
    """
    if secret_key is None:
        raise RuntimeError("no secret key defined")

    result = []
    mac = hmac(to_bytes(secret_key), None, hash_method)

    for key, value in sorted(data.items()):
        result.append(
            (
                "{}={}".format(key, value)
            ).encode("ascii")
        )
        mac.update(b"|" + result[-1])

    return b"?".join([base64.b64encode(mac.digest()).strip(), b"&".join(result)])

print(serialize({'very_auth': 'admin'}, 'peanut butter'))