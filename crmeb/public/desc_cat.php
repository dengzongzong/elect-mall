<?php
$p = new PDO('mysql:host=127.0.0.1;dbname=mall_db;charset=utf8mb4','root','123456');
$r = $p->query('DESCRIBE category');
foreach($r as $c) {
    echo $c['Field'] . '  ' . $c['Type'] . '  ' . ($c['Null']=='YES'?'NULL':'NOT NULL') . '  ' . ($c['Default']??'') . "\n";
}