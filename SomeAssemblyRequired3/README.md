# Solution

The following steps are the same as SomeAssemblyRequired2

```bash
# Get the web assembly file
$ curl http://mercury.picoctf.net:47240/qCCYI0ajpD -o script.wasm

# Decompile to user friendly format using wabt. 
$ ./wasm-decompile script.wasm
```

From the decompiled code, we see that the flag is encoded again
```
data d_nA372e6(offset: 1024) =
  "\9dn\93\c8\b2\b9A\8b\94\c6\df3\c0\c5\95\de7\c3\9f\93\df?\c9\c3\c2\8c2\93"
  "\90\c1\8ee\95\9f\c2\8c6\c8\95\c0\90\00\00";
```

And in the copy method, we see that there's some shenigans going on
```
function copy(a:int, b:int) {
  var c:int = g_a;
  var d:int = 16;
  var e:int_ptr = c - d;
  e[3] = a;
  e[2] = b;
  var f:int = e[3];
  if (eqz(f)) goto B_a;
  var g:int = 4;    
  var h:int = e[2];         // 0, 1, 2, 3, ..., len(s)
  var i:int = 5;    
  var j:int = h % i;        // j = 0, 1, ..., 4
  var k:ubyte_ptr = g - j;  // k = 0, 1, ..., 4
  var l:int = k[1067];      // Magic byte at k[1067], [237, 7, 240, 167, 241]
  var m:int = 24;
  var n:int = l << m;       
  var o:int = n >> m;       // o = ( l << 24 ) >> 24
  var p:int = e[3];
  var q:int = p ^ o;        // q = ord(a) ^ l
  e[3] = q;
  label B_a:
  var r:int = e[3];
  var s:byte_ptr = e[2];
  s[1072] = r;
}
```

Since we can access the memory on run time. We can find get the magic bytes as follows.
```js
arr = new Uint8Array(exports["memory"].buffer, 1067, 5);    // [ 241, 167, 240, 7, 237 ]
```

And since our flag is also encoded as hex. Instead of cleaning it in python, we can just do the same as above.
```js
arr = new Uint8Array(exports["memory"].buffer, 1024, 64);
// "157,110,147,200,178,185,65,139,148,198,223,51,192,197,149,222,55,195,159,147,223,63,201,195,194,140,50,147,144,193,142,101,149,159,194,140,54,200,149,192,144,0,0,241,167,240,7,237,157,110,147,200,178,185,65,139"
```

Now all we have to do is to XOR the numbers to get the decoded flag. `a = b ^ c; b = a ^ c`. To decode an XOR'd value, we just need to XOR it again.

```python
magic = [237, 7, 240, 167, 241]
mem = "157,110,147,200,178,185,65,139,148,198,223,51,192,197,149,222,55,195,159,147,223,63,201,195,194,140,50,147,144,193,142,101,149,159,194,140,54,200,149,192,144,0,0,241,167,240,7,237,157,110,147,200,178,185,65,139"

nums = [int(num) for num in mem.split(",")]
xor = [num ^ magic[i % len(magic)] for i, num in enumerate(nums)]
flag = ''.join([chr(num) for num in xor])

print(flag) 
# picoCTF{37240bd3038b289d3a5c70cbe83a1821}ðVV:B°f
```
