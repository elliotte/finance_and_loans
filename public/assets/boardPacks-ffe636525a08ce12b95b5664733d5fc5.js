
var reportsSharedHelper = (function() {
      return {
        notUsed: function() {
            // OLD FUNCTION
        },
        // END OF FUNCTION
      };
      // END OF RETURN
})();

function commonDownloadPopup(link){
  $('#bg-screen-for-modal').addClass('open')
  html = '<article class="type-system-slab">' + '<p>' + 'Successful Export: ' + link + '</p>' + '</article>'
  $('#bg-screen-for-modal').find('section').empty().append(html)
}
;
