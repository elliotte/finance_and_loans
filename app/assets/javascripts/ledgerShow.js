
var cashLedgerShow = (function() {
		
  	  var showPageData = {
      	'Payments' : "",
      	'Lodgements' : "",
      	'Timeline' : ""
  	  };      

      return {

          getPaymentsData: function() {
          	var data = [["Tag", "Amount"]]
          	var paymentRows = $('.payment_line')
          	for (i = 0; i < paymentRows.length; i++) { 
  		        var tag_desc = $(paymentRows[i]).data('tag')
  		        var total_amount = parseFloat($(paymentRows[i]).data('total'))
  		        data.push([tag_desc, total_amount])
		        }
		        return data
          },

          getLodgementsData: function() {
          	var data = [["Tag", "Amount"]]
          	var lodgementRows = $('.lodgement_line')
          	for (i = 0; i < lodgementRows.length; i++) { 
  		        var tag_desc = $(lodgementRows[i]).data('tag')
  		        var total_amount = parseFloat($(lodgementRows[i]).data('total'))
  		        data.push([tag_desc, total_amount])
		        }
		        return data
          },

          getTimeLineData: function() {
          	var data = [["Desc", "Amount"]]
          	var timeLineData = $('.transaction-line')
          	for (i = 0; i < timeLineData.length; i++) { 
  		        // var date = $(timeLineData[i]).data('date')
              var desc = $(timeLineData[i]).data('desc')
  		        var total_amount = parseFloat($(timeLineData[i]).data('total'))
  		        data.push([desc, total_amount])

    		    }
          	return data
          },

          loadData: function() {
          	showPageData["Payments"] = this.getPaymentsData();
          	showPageData["Lodgements"] = this.getLodgementsData();
          	showPageData["Timeline"] = this.getTimeLineData();
          	return showPageData
          }, 

          displayShareLedgerModal: function() {

              $('#empty-modal-table').empty();
              $('#table-title').empty();

              $('#modal-table-empty').trigger('click')

              friends = JSON.parse(localStorage.getItem("friends")).items
              link = '<a href="javascript:void(0)" onclick="cashLedgerShow.shareLedger(this)">' + 'Share' + '</a>'
              $('#empty-modal-table').append('<p style="color:#F3655E;font-size:80%;">' + 'You can search your friends list using the browser CTRL + F feature' + '</p>')
              $.each(friends, function(index, person) {
                imgSrc = person.image.url
                html = '<tr id="' + person.id + '">' + 
                    '<td>' + '<img src="' + imgSrc + '" >' + '</td>' +
                    '<td>' + person.displayName + '</td>' +
                    '<td>' + link + '</td>' +
                '</tr>'
                $('#empty-modal-table').append(html);

              });

          },

          shareLedger: function(obj) {

            shareUserID = obj.parentNode.parentNode.getAttribute('id');

            var token = $("meta[name='csrf-token']").attr("content");
            ledgerID = $('#ledger-id').text()

            var request = new XMLHttpRequest();
                  request.onload = shareSuccess;
                  //request.onerror = errorDisplay;
                  data = {
                    userID: shareUserID,
                  }
                  route = '/ledgers/' + ledgerID + '/share'
                  console.log(route)
                  request.open("put", route, true );
                  request.setRequestHeader("Content-Type", "application/json");
                  request.setRequestHeader("X-CSRF-Token", token);
                  request.send(JSON.stringify(data));
          },

          setSummaryModals: function() {
          // SETS LISTENERS AND INSTRUCTIONS
              // SHOW PAGE VIEW GRANDULAR TRANSACTIONS FOR SUMMARY BY TAG
              $('.lodgement-summary-display').on('click', function() {
                    table = document.getElementById('empty-modal-table');
                    $(table).empty();
                    _tag = $(this).data('tag')
                    // MAP AND COLLECT DEBITS WITH MATCHING TAG
                    trns =  collectTrns(_tag, 'Debit') 
                     // END OF COLLECT TRNS FOR TAG
                    appendToTable(_tag);
                    $('#modal-table-empty').trigger('click');
                   
              });
              // END OF LODGEMENT JS
              // START OF PAYEMENTS
              $('.payments-summary-display').on('click', function() {
                    table = document.getElementById('empty-modal-table');
                    $(table).empty();

                    tag = $(this).data('tag')
                    // MAP AND COLLECT CREDITS WITH MATCHING TAG
                    trns =  collectTrns(tag, 'Credit')
                    console.log(trns);
                     // END OF COLLECT TRNS FOR TAG
                    appendToTable(tag);
                    $('#modal-table-empty').trigger('click');
              });
              // END OF PAYMENTS SUMMARY

              // HELPER METHODS FOR RESET
              function collectTrns(tag, type) {
                  // COLLECT TRANS
                  trns = $.map($('.transaction-line'), function( trn, i) {
                        _trn = $(trn)
                        if (_trn.data('tag') == tag && _trn.data('type') == type) {
                            return _trn
                        }
                  })  
                  return trns
              };
              // END OF COLLLECT HELPER
              // APPEND TO TABLE HELPER
              function appendToTable(tag) {
                  $(trns).each(function(i, trn) {
                        html = '<tr>' +
                                  '<td>' + 
                                      $(trn).data('date') +
                                  '</td>' +
                                  '<td>' + 
                                      $(trn).data('total') +
                                  '</td>' +
                                  '<td>' + 
                                      $(trn).data('desc') +
                                  '</td>' +
                                  '<td>' + 
                                        $(trn).data('tag') +
                                  '</td>' + 
                               '</tr>'
                        $(table).append(html)
                    })
                    $('#table-title').empty();
                    $('#table-title').append(tag)
              };
              // END OF APPEND TO TABLE
          }  
          // END OF reSET METHOD
      };

})();


function shareSuccess() {
    
    $('#empty-modal-table').empty(); 
    response = this.responseText

    if (response.indexOf("ERROR") > -1) {
      html = '<p>' + 'ERROR' + '</p>' +
           '<a href="/" data-no-turbolinks=true>' + 'RECONNECT' + '</a>'
    } else {
      html = '<td>' + 'Successfully shared Ledger with: ' + response + '</td>'
    }
    $('#empty-modal-table').append(html) 

};





