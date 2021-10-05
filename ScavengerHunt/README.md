Scavanger Hunt Website

# Solution

Inspect html, css, and js files

## Part 1 in html file:

`picoCTF{t`

## Part 2 in mycss.css:

`h4ts_4_l0`

## Part 3 in myjs.js:

We find the following comments below myjs.js file
```js
/* How can I keep Google from indexing my website? */
```

To prevent google from indexing your website, it's either with a `<meta> tag`, `HTTP response header`, or `robots.txt`

Checking the site, it does not have `<meta> tag`, nor does it contain `X-Robots-Tag` in the Response Header.

Hence we can check the site's robots.txt

```bash
curl http://mercury.picoctf.net:39698/robots.txt
```

And there is the 3rd flag 

```bash
User-agent: *
Disallow: /index.html
# Part 3: t_0f_pl4c
# I think this is an apache server... can you Access the next flag?
```

The 3trd flag is `t_0f_pl4c`

## Part 4

Solution from [Dvd848](https://github.com/Dvd848/CTFs/blob/master/2021_picoCTF/Scavenger_Hunt.md)

Use `dirsearch` to get list of common files publicly available.

```bash
$ dirsearch -u http://mercury.picoctf.net:39491/ -e *

  _|. _ _  _  _  _ _|_    v0.4.1
 (_||| _) (/_(_|| (_| )

Extensions: --no-color | HTTP method: GET | Threads: 30 | Wordlist size: 8979

Output File: /home/alex/.dirsearch/reports/mercury.picoctf.net/_21-09-12_11-56-57.txt

Error Log: /home/alex/.dirsearch/logs/errors-21-09-12_11-56-57.log

Target: http://mercury.picoctf.net:39698/

[11:56:58] Starting: 
[11:57:07] 200 -   62B  - /.DS_Store
[11:57:12] 200 -   95B  - /.htaccess
[11:57:12] 200 -   95B  - /.htaccess/
[11:58:50] 200 -  961B  - /index.html
[11:59:26] 200 -  124B  - /robots.txt
```

`.htaccess` is a Apache configuration file. Normally this should be hidden.

The 4th flag is `3s_2_lO0k` and is found in htaccess

## Part 5

The 5th flag is `_fa04427c}` and is found in /.DS_Store

Finally combine all the parts into `picoCTF{th4ts_4_l0t_0f_pl4c3s_2_lO0k_fa04427c}`