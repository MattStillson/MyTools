'use strict';
var WmiClient = require('wmi-client');
var ip = '127.0.0.1';

var wmi = new WmiClient({
    username: 'ultimatemedical\\mstillson',
    password: 'Polycom2017!',
    host: 'ip'
});

wmi.query('SELECT * FROM Win32_OperatingSystem', function (err, result) {
    console.log(result);
});