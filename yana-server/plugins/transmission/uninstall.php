<?php


$conf = new Configuration();
$conf->getAll();
$conf->remove('ip','transmission');
$conf->remove('port','transmission');
$conf->remove('user','transmission');
$conf->remove('pswd','transmission');


?>