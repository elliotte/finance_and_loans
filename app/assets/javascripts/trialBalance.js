
var trialBalanceHelper = (function() {
    
      return {
          // END OF FILTERBYDATE FUNCTION
          setGLTableListeners: function(trnID) {
                
                $('.ledger_account').on('click', function() { 
                      
                      $('#empty-modal-body-append').children().hide(); 
                      
                      var ledger_account = $(this).data('key')  
                      var table = document.getElementById(ledger_account)
                      
                      $("#modal-empty").trigger("click")
                      $('#empty-modal-body-append').append(table) 
                      $('#empty-modal-body-append').prepend('<p>' + ledger_account + '</p>') 

                      if ($(table).css('display') == 'none') {
                        $(table).css('display', 'initial');
                      } else { 
                        $(table).css('display', 'none');
                      }

                      $(".modal-close").on("click", function() {
                          $(".modal-state:checked").prop("checked", false).change();
                      });
                });
                // END OF display Function
          },
          // END OF setTableListeners
          exportTBToGoogle: function() {

                // RAILS 4 HAS TAKEN OUT AUTO POPULATING CRSF AUTH TOKEN
                var token = $("meta[name='csrf-token']").attr("content");

                tbAmts = $('.key-total-line')
                exportRows = []

                $.each(tbAmts, function(index, GLTotal ) {
                    tbLine = {
                      reportingLine: $(GLTotal).data('key'),
                      lineAmount: $(GLTotal).data('amount')
                    }
                    exportRows.push(tbLine)
                })

                var request = new XMLHttpRequest();
                  request.onload = successDisplay;
                  request.onerror = errorDisplay;

                  request.open("post", '/cash_ledgers/' + $('#tb-id').text() + '/export_tb_google', true );
                  request.setRequestHeader("Content-Type", "application/json");
                  request.setRequestHeader("X-CSRF-Token", token);
                  request.send(JSON.stringify(exportRows));
          },
          // END OF TB EXPORT FUNCTION
          exportGLToGoogle: function() {

              var token = $("meta[name='csrf-token']").attr("content");

              glData = $('.gl-export-data')
              exportRows = []

              $.each(glData, function(index, GLTrn ) {
                  _trn = $(GLTrn)
                  glTrnLine = {
                    //gl == monea_tag
                    glName: _trn.data('gl-name'),
                    trnID: _trn.data('id'),
                    amt: _trn.data('amt'),
                    tag: _trn.data('tag'),
                    date: _trn.data('date'),
                    description: _trn.data('desc'),
                    
                  }
                  exportRows.push(glTrnLine)
              })
              
              var request = new XMLHttpRequest();
                  request.onload = successDisplay;
                  request.onerror = errorDisplay;

                  request.open("post", '/cash_ledgers/' + $('#tb-id').text() + '/export_gl_google', true );
                  request.setRequestHeader("Content-Type", "application/json");
                  request.setRequestHeader("X-CSRF-Token", token);
                  request.send(JSON.stringify(exportRows));
          },
          // END OF GL EXPORT FUNCTION

      }
      // END OF RETURN

})();          

function errorDisplay() {

    console.log('errrrrrrr')
    $('#empty-modal-body-append').children().hide(); 
    $("#modal-empty").trigger("click")
    
    $('#empty-modal-body-append').empty();
    html = '<p>' + "ERROR SOMETHING WENT WRONG" + '</p>' +
           '<a href="/" data-no-turbolinks=true>' + 'RECONNECT' + '</a>'
    $('#empty-modal-body-append').append(html) 

};

function successDisplay() {
    
    $('#empty-modal-body-append').children().hide(); 
    $("#modal-empty").trigger("click")


    link_href = this.responseText
    
    if (link_href.indexOf("ERROR") > -1) {
      html = '<p>' + 'ERROR' + '</p>' +
           '<a href="/" data-no-turbolinks=true>' + 'RECONNECT' + '</a>'
    } else {
      html = '<p>' + 'Successfully exported' + '</p>' +
           '<a href="'+link_href+'" target="_blank">' + 'View Export' + '</a>'
    }
    
    $('#empty-modal-body-append').append(html) 

};


