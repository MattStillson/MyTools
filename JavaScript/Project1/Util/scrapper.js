var request = require('request');
var cheerio = require('cheerio');

request('https://news.ycombinator.com', function (error, response, html) {
    if (!error && response.statusCode == 200) {
        console.log(html);
    }
});
/*
or
request('https://news.ycombinator.com', function (error, response, html) {
  if (!error && response.statusCode == 200) {
    var $ = cheerio.load(html);
    $('span.comhead').each(function(i, element){
      var a = $(this).prev();
      console.log(a.text());
    });
  }
});

or

request('https://news.ycombinator.com', function (error, response, html) {
  if (!error && response.statusCode == 200) {
    var $ = cheerio.load(html);
    $('span.comhead').each(function(i, element){
      var a = $(this).prev();
      var rank = a.parent().parent().text();
      var title = a.text();
      var url = a.attr('href');
      var subtext = a.parent().parent().next().children('.subtext').children();
      var points = $(subtext).eq(0).text();
      var username = $(subtext).eq(1).text();
      var comments = $(subtext).eq(2).text();
      // Our parsed meta data object
      var metadata = {
        rank: parseInt(rank),
        title: title,
        url: url,
        points: parseInt(points),
        username: username,
        comments: parseInt(comments)
      };
      console.log(metadata);
    });
  }
});

var fs = require('fs'),
    request = require('request'),
    cheerio = require('cheerio'),
    pageURL = 'http://output.jsbin.com/xavuga';

function scrapePage () {
    //make an HTTP request for the page to be scraped
    request(pageURL, function(error, response, responseHtml){

        //write the entire scraped page to the local file system
        fs.writeFile(__dirname + '/HTML/entire-page.html', responseHtml, function(err){
            console.log('entire-page.html successfully written to HTML folder');
        })
    }) ;
}

//scrape the page
scrapePage();

**/