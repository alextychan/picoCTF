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
