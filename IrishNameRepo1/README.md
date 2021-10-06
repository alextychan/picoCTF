# Solution

This is a SQL injection challenge.

When we submit a login request, the form also includes a `debug` field. Set `debug=1` to view the generated SQL.

Submit the following to receive the flag `username=tom&password=' or '1'='1&debug=1`. 

Flag is `picoCTF{s0m3_SQL_c218b685}`