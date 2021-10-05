# Solution

The hint points us to a HTTP RFC. While reading the whole thing is quite the feat, we can make an educated guess that it's something to do with modifying our requests.

Going to the challenge page first presents us with
```
Only people who use the official PicoBrowser are allowed on this site!
```

`User-Agent` is used to describe what type of browser is used. Let's set `User-Agent: PicoBrowser` and resend the request.

```
I don't trust users visiting from another site.
```

`Referer` contains the absolute or partial address of the page making the request. Let's set `Referer: http://mercury.picoctf.net:46199/` and resend the request.

```
I don't trust users who can be tracked.
```

`DNT` is a header that indicates that users do not want to be tracked. (No longer recommended). Let's set `DNT: 1`

```
Sorry, this site only worked in 2018.
```

`Date` contains the date and time at which the message was originated. (It is listed as a forbidden header name in the fetch spec). But for the purpose of this challenge we need to set `Date: Tue, 6 Feb 2018`

```
This website is only for people from Sweden.
```

`X-Forwarded-For` is a header used to identify the originating IP address of a client. Let's set `X-Forwarded-For: 104.107.224.0`. The ip address must be from Sweden. The valid ip ranges can be found online.

```
You're in Sweden but you don't speak Swedish?
```

`Accept-Language` tells the server which language the client is able to understand and which locale is preferred. Let's set `Accept-Language: sv-SE`

```
picoCTF{http_h34d3rs_v3ry_c0Ol_much_w0w_8d5d8d77}
```