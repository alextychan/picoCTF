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


print(serialize({'very_auth': 'admin'}, 'peanut butter'))