# Solution

Challenge presents us with a webpage. Clicking on the flag button produces an error saying 'we're not picobrowser'

All we have to do is fake the [`User-Agent`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent).

```bash
$ curl https://jupiter.challenges.picoctf.org/problem/28921/flag -H 'User-Agent: picobrowser'

# And our flag is somewhere within the output
# picoCTF{p1c0_s3cr3t_ag3nt_84f9c865}
```