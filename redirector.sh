#!/bin/bash

sed "s/__DIR__/$1/g" << !!!
<html>
<head>
<title>Redirect</title>
<meta http-equiv="Refresh" content="0; url=/__DIR__/check_mk/" />
</head>
<body>
<p>Please start here: <a href="/__DIR__/check_mk/">/__DIR__/check_mk/</a></p>
</body>
</html>
!!!

