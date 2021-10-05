# Solution

Download wasm source. (Link can be found in network tab)
```
curl http://mercury.picoctf.net:7319/aD8SvhyVkb -o web_assm.wasm
```

Make sure [wabt](https://github.com/WebAssembly/wabt) is downloaded.

Decompile wasm into pseudo-code

```
./wasm-decompile script.wasm -o script.dcmp
```

Our flag is stored in the data section.
```
data d_xakgKNs989l1im8i890088k09nj9(offset: 1024) =
"xakgK\Ns9=8:9l1?im8i<89?00>88k09=nj9kimnu\00\00"
```

Looks like it's encoded somehow.
```
export function check_flag():int {
  var a:int = 0;
  var b:int = 1072;
  var c:int = 1024;
  var d:int = strcmp(c, b);
  var e:int = d;
  var f:int = a;
  var g:int = e != f;
  var h:int = -1;
  var i:int = g ^ h;
  var j:int = 1;
  var k:int = i & j;
  return k;
}

function copy(a:int, b:int) {
  var c:int = g_a;
  var d:int = 16;
  var e:int_ptr = c - d;
  e[3] = a;
  e[2] = b;
  var f:int = e[3];
  if (eqz(f)) goto B_a;
  var g:int = e[3];
  var h:int = 8;
  var i:int = g ^ h;            ; a ^ b
  e[3] = i;                     ; a = a ^ b
  label B_a:
  var j:int = e[3];
  var k:byte_ptr = e[2];
  k[1072] = j;
}
```

In the copy function, we see that our input a is XOR'd with 8. Let's try XOR the encoded flag.

```python
val = "xakgK\\Ns9=8:9l1?im8i<89?00>88k09=nj9kimnu"

print(''.join([chr(ord(ch) ^ 8) for ch in val]))
```

And our flag is 
```
picoCTF{15021d97ae0a401788600c815fb1caef}
```