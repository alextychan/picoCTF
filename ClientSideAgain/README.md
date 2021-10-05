# Solution

This is another client side validation challenge.

The javascript is located inside the `script` tag of our webpage.

Hence we should copy the script and prettify it locally.

The challenge has obfuscated code by partially embedding strings inside an array, and the strings inside the array are already scrambled. To make life easier, we can set a break point inside the `verify` function and enter a dummy password to get the unscrambled string array.

```js
unscrambled = [ "getElementById", "value", "substring", "picoCTF{", "not_this", "f49bf}", "_again_e", "this", "Password Verified", "Incorrect password" ]
```

function `_0x4b5b` is used to get our string. And by observation we get the following substitutions.

```js
_0x4b5b("0x2")      // substring
_0x4b5b("0x3")      // picoCTF{
_0x4b5b("0x4")      // not_this
_0x4b5b("0x5")      // f49bf}
_0x4b5b("0x6")      // _again_e
_0x4b5b("0x7")      // this
```

Now all that's left is to calculate the substring indices and join the strings manually
```js
split = 0x4
// flag: picoCTF{not_this_again_ef49bf}
if (checkpass["substring"](0x0, 0x8) == _"picoCTF{") {
    // 0 - 7: picoCTF{
    if (checkpass["substring"](0x7, 0x9) == "{n") {
      if (
        checkpass["substring"](0x8, 0x10) ==
        "not_this"
      ) {
        // 8 - 15: not_this
        if (checkpass["substring"](0x3, 0x6) == "oCT") {
          if (
            checkpass["substring"](0x18, 0x20) ==
            "f49bf}"
          ) {
            // 24 - 32: f49bf}
            if (checkpass["substring"](0x6, 0xb) == "F{not") {
              if (
                checkpass["substring"](
                  split * 0x2 * 0x2,
                  split * 0x3 * 0x2
                ) == "_again_e"
              ) {
                // 16 - 23: _again_e
                if (checkpass["substring"](0xc, 0x10) == "this") {
                  alert(_0x4b5b("0x8"));
                }
              }
            }
          }
        }
      }
    }
  }
```