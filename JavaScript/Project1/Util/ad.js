'use strict';
var ActiveDirectory = require('activedirectory');
var ad = new ActiveDirectory(config);

var groupName = 'O365SkypeUsers';

ad.getUsersForGroup(groupName, function (err, users) {
    if (err) {
        console.log('ERROR: '+JSON.stringify(err));
        return;
    }

    if (!users) console.log('Group: ' + groupName + ' not found.');
    else {
        console.log(JSON.stringify(users));
    }
});