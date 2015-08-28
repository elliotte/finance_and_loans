
var ready;
ready = function() {

    salesLedgerShow.drawCharts();

};

$(document).ready(ready);
$(document).on('page:load', ready);

var salesLedgerShow = (function() {
  	  var showPageData = {
      	'Timeline' : ""
  	  };      
      return {

          drawCharts:function() {
            data = this.loadData()
            graphHelper.drawCharts(data);
          },
          
          loadData:function() {
            var data = [["Desc", "Amount", { role: 'annotation' }]]
            var timeLineData = $('.sales-trn-line')
            for (i = 0; i < timeLineData.length; i++) { 
              var date = $(timeLineData[i]).data('inv-date')
              var desc = $(timeLineData[i]).data('inv-desc')
              var amt = parseFloat($(timeLineData[i]).data('inv-amt'))
              data.push([desc, amt, date])
            }
            return data
          },

      };

})();

// FOR INVOICE PAID AND FILE UPDTE
var confirmText = "Please be sure, this cannot be reversed without special assistance.. as part of our business ledger control procedures"

// UPDATES TRN TO PAID RETURNS SUCCESS CHANGES DOM THEN UPDATES GOOGLE DRIVE
function upDateTrnPaid(button) {
    id = $(button).data('trn-id')
    if (confirm(confirmText) == true) {
            var token = $("meta[name='csrf-token']").attr("content");
            var request = new XMLHttpRequest();
              request.onload = successPaid;
//              request.onerror = errorDisplay;
              data = {
                id: id
              };
              request.open("put", '/transactions/' + id + '/invoice_paid', true );
              request.setRequestHeader("Content-Type", "application/json");
              request.setRequestHeader("X-CSRF-Token", token);
              request.send(JSON.stringify(data));
    } else {
        return
    }
}
// END OF updateTRNPAID
function successPaid(trn) {
    _trn = JSON.parse(this.responseText)
    if (_trn.paid) {
        cellString = '#' + _trn.id + '-paid-button-cell'
        $(cellString).html("Yes")
        var flashText = '<p style="color:#f3655e;">' 
        + 'Success; Invoice marked as Paid : ' + '<a href="'+_trn.invoice_file_link+'" target="_blank"style="text-decoration:none;">' 
        + ' View Invoice'+ '</a>' + '</p>';
        updateGoogleFileTitle(_trn.id)
        $(".notice").html('<div>'+flashText+'</div>');
    } else {
      console.log('updated trn not paid per JS CHECK')
    }
}
// END OF SUCCESS PAID
function updateGoogleFileTitle(trnID) {
    var token = $("meta[name='csrf-token']").attr("content");
    var request = new XMLHttpRequest();
    request.onload = successFileInvPaid;
    //request.onerror = errorHome;
    data = {
      trnID: trnID
    };
    request.open("put", '/transactions/' + trnID + '/update_invoice_file_paid', true );
    request.setRequestHeader("Content-Type", "application/json");
    request.setRequestHeader("X-CSRF-Token", token);
    request.send(JSON.stringify(data));
}
// END OF GOOGLE UPDATE
function successFileInvPaid() {
    if (this.responseText == "ERROR") {
        $(".notice").html('<p>'+"AUTH ERROR"+'</p>');
        window.location.href = "/";
    } else {
        file = JSON.parse(this.responseText)
        var flashText = '<p style="color:#f3655e;">' 
        + 'AND: invoice updated: ' + '<a href="'+file.alternateLink+'" target="_blank"style="text-decoration:none;">' 
        + ' View Invoice'+ '</a>' + '</p>';
        $(".notice").html('<div>'+flashText+'</div>');
    }
}
// END OF SUCCESS GOOGLE FILEUPDATE


;
