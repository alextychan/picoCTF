Inspect shark1.pcapng file for the flag

# Solution

Searching through the packet list, details, bytes turns out nothing.

Manually searching through the requests.

Found a HTTP request which contains what looks like the flag but encoded as a ROT13 string.

```bash
# Found the value under this request
827	7.236537	18.222.37.134	192.168.38.104	HTTP	384	HTTP/1.1 200 OK  (text/html)
```

```bash
# Source
cvpbPGS{c33xno00_1_f33_h_qrnqorrs}
```

```bash
# Value
picoCTF{p33kab00_1_s33_u_deadbeef}
```