# Solution

We follow the same steps as the previous challenge to obtain the assembly file.

```bash
# Get source file
$ curl "http://mercury.picoctf.net:41165/ZoRd23o0wd" -o script.wasm

# Decompile to readable format
$ ./wasm-decompile script.wasm -o script.dcmp
```

This challenge is different as the encoding logic is hidden away inside the check_flag function itself. As the output is a little long, we'll not show it here.

Instead of going through the decompiled code, what we can do is try to brute force it.

From the `copy_char()` function, our input is first copied to `offset 1072`.
```
function copy(a:int, b:int) {
  var c:int = g_a;
  var d:int = 16;
  var e:int_ptr = c - d;        // e points to a location in our heap
  e[3] = a;
  e[2] = b;
  var f:int = e[3];
  var g:byte_ptr = e[2];
  g[1072] = f;                  // our character is copied to an offest from [1072 + b] onwards.
}
```

And we know that the flag is stored in `offset 1024`.
```
data d_ja8i7HJhKow4kPpOEoL(offset: 1024) =
"\18j|a\118i7[H~Jh^Ko\1f]\w4kP\15pO?\Eo\14\06\05}>=\04\16.\12L\00\00";
```

Now all we have to do is compare the values stored in `offset 1072` and `offset 1024` to get our flag.

First let's get both arrays.
```js
arr = new Uint8Array(exports["memory"].buffer, 1024, 42); // flag
arr2 = new Uint8Array(exports["memory"].buffer, 1072, 42); // our input
```

Now let's write a function that compares the values in the array.
```js
function check() {
  // We'll only check the front 16 characters to find the pattern.
  for (let i = 0; i < 16; i++) {
    if (arr[i] != arr2[i]) {
      console.log(`i: ${i}, expected: ${arr[i]}, actual: ${arr2[i]}`)
    }
  }
}
```

From previous challenges, we know that the format of the flag is `picoCTF{your_flag_here}`. So let's try the following sequences.

```
picoCTF{aaaaaa}    => actual: [77, 9, 46, 94, 60, 26, 115, 0]
picoCTF{baaaaa}    => actual: [78, 10, 46, 94, 60, 26, 115, 0]
```

One character's difference caused 2 values to change. This shows that we should brute force the flag 2 characters at a time.

```js
const fs = require('fs')

WebAssembly.instantiate(fs.readFileSync('./SomeAssemblyRequired4/script.wasm')).then(({ module, instance }) => {
    let start = "picoCTF{"
    let arr = new Uint8Array(instance.exports.memory.buffer, 1024, 64)
    let arr2 = new Uint8Array(instance.exports.memory.buffer, 1072, 64)
    for (let i = 8; i < 40; i += 2) {
        let found = false;
        for (let k = 32; k < 128; k++) {
            for (let l = 32; l < 128; l++) {
                for (let j = 0; j < i; j++) {
                    instance.exports.copy_char(start.charCodeAt(j), j);
                }
                instance.exports.copy_char(k, i);
                instance.exports.copy_char(l, i + 1);
                instance.exports.check_flag();
                if (arr[i] == arr2[i] && arr[i+1] == arr2[i+1]) {
                    start += String.fromCharCode(k) + String.fromCharCode(l);
                    found = true;
                    break;
                }
            }
            if (found) {
                break;
            }
        }
    }
    console.log(start + "}");
});
```

And our flag is `picoCTF{ 6cdceedc31e02d455b03fff6f3b1288}`.

Special thanks to [Larry Yuan](https://larry.science/post/picoctf-2021/) and [Martin Carlisle](https://www.youtube.com/watch?v=EsnzsnIN0YI) for inspiring this solution.