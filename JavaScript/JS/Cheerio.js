var request = require('request');
var cheerio = require('cheerio');

function(err, resp, html) {
        if (!err){
          const $ = cheerio.load(html);
          console.log(html);
      }
});