# AES-CBC Bit Flip Attack

We're assuming that there's a single bit inside the cookie that represents something like `auth=0`. And by flipping the bit, we can set it to `auth=1`

```
// Original decoded cookie
XMp3c0iA6+k2MnMvZuUX8OLPWYqNFeCCU9b8a/qM+dCDcRDTaLFb7OyVJgvbPZcf0+gIthrELus+hs6gfeIQS30B6slBqdu0fn083Pw5vXdhgfeVv1iRH5laAoRUhGEQ

// Flipped decoded cookie
XMp3c0iA6+k2M3MvZuUX8OLPWYqNFeCCU9b8a/qM+dCDcRDTaLFb7OyVJgvbPZcf0+gIthrELus+hs6gfeIQS30B6slBqdu0fn083Pw5vXdhgfeVv1iRH5laAoRUhGEQ
```

Flag: `picoCTF{cO0ki3s_yum_e40d16a9}`
