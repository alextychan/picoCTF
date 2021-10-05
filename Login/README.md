# Solution

Inspecting the webpage, we see that there is a index.js. Pretty printing the source shows that the password check is done locally.

```js
(async() =>{
  awaitnew Promise((e=>window.addEventListener('load', e))),
  document.querySelector('form').addEventListener('submit', (e=>{
    e.preventDefault();
    const r = {
      u: 'input[name=username]',
      p: 'input[name=password]'
    },
    t = {
    };
    for (const e in r) t[e] = btoa(document.querySelector(r[e]).value).replace(/=/g, '');
    return 'YWRtaW4' !== t.u ? alert('Incorrect Username')  : 'cGljb0NURns1M3J2M3JfNTNydjNyXzUzcnYzcl81M3J2M3JfNTNydjNyfQ' !== t.p ? alert('Incorrect Password')  : void alert(`Correct Password! Your flag is ${atob(t.p)
  }
  .`)
}))
}) ();
```

We just need to decode `cGljb0NURns1M3J2M3JfNTNydjNyXzUzcnYzcl81M3J2M3JfNTNydjNyfQ` from base64 to ascii.

```
"picoCTF{53rv3r_53rv3r_53rv3r_53rv3r_53rv3r}"
```