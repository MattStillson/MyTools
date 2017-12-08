var Nightmare = require('nightmare');
var cheerio = require('cheerio');
var nightmare = Nightmare({ show: true })

nightmare
  .goto('https://testuri.org')
  .wait(300)
  .evaluate(
    function(){
      return document.body.innerHTML;
    })
  .end()
  .then(function (result) {
    console.log(result);
  })
  .wai
  .catch(function (error) {
    console.error('Cant get your body: ', error);
  });

  <a href="javascript:void(0);" class="DataFormChildDataGridPagerLink theme_background_color" onclick="__doPostBack('ListControl_365f8b73-7c37-4008-8ac7-801e3d9f3a34','1');"></a>