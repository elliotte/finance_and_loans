
var cashLedgerMgr = (function() {
    
      return {

          filterByDate: function() {
              
              var start_date = new Date( $('#from_date_2i').val() + '/' + $('#from_date_3i').val() + '/' + $('#from_date_1i').val() )
              var end_date = new Date( $('#to_date_2i').val() + '/' + $('#to_date_3i').val() + '/' + $('#to_date_1i').val() )
              
              console.log(end_date, start_date)
              allAccDates = $('.trn-acc-date')

              $.each(allAccDates, function(index, transaction){
                
                  dateString = $(transaction).text().split('/').reverse().join('/')

                  trnDate = new Date (dateString)
                  trnId = $(transaction).parent().attr('id')

                  filterData()
                
              });
              function filterData(){
                    if (start_date <= trnDate && trnDate <= end_date ) {
                      console.log('inScope')
                      $('#' + trnId).show();
                    } else {
                      console.log('not inScope')
                      $('#' + trnId).hide();
                    }
              };  
              // END OF FILTER FUNCTION
          },
          // END OF FILTERBYDATE FUNCTION

          filterByMoneaTag: function(select) {

              filterTag = $(select).val();
              allTags = $('.trn-monea-tag')

              $.each(allTags, function(index, transaction){
                  
                  trnId = $(transaction).data('trn-id')
                  trnTag = $(transaction).data('monea-tag')

                  if (filterTag == trnTag ) {
                      console.log('inScope')
                      $('#' + trnId).show();
                  } else {
                      console.log('not inScope')
                      $('#' + trnId).hide();
                  }

              });

          },

          displayTransaction: function(trnID) {
              ledgerID = $('#ledger-id').data('id')

              $.ajax({
                  type: 'GET',
                  url: '/transactions/' + trnID + '?' + 'ledger_id=' + ledgerID,
                  data: { ledger_id: ledgerID },
                  success: function() {
                  },
                  error: function() {
                    // TO ADD FIRE LOADING MODAL AND APPEND ERROR
                  }
              });
          },
          // END OF display Function
      }
      // END OF RETURN

})();          


$(document).on('click', '#transactions-filter', function(e){
  
    e.preventDefault();
    orderByVariable = $($('.summary')[0]).text();
    $('#modal-loading-manager').trigger('click')
    console.log(orderByVariable)
    var ledgerID = $('#ledger-id').data('id')

    $.ajax({
        type: 'GET',
        url: '/cash_ledgers/' + ledgerID + '/order_filter',
        data: {filter: orderByVariable },
        success: function() {
        },
        error: function() {
          // TO ADD FIRE LOADING MODAL AND APPEND ERROR
        }
    });

})



// function iDsAndIndex(trns, orderFilter) {
//   var data = []
//   $.each(trns, function(index, transaction){

//       data.push(transaction.monea_tag, index)  

//   });
//   return data;
// }



// function updateData(data){
//   console.log(data)
//   $('#top-of-tran-list').html('');
//   html = ''
//   $.each(data, function(i, transaction){
//     html += getTransactionTemplate(transaction);
//   })
//   $('#top-of-tran-list').html(html)
// }

// function cacheTransactionData(transactions){
//   clearLocalStorage('transactions');
//   localStorage.setItem('transactions', JSON.stringify(transactions));
// }

// function getTransactionTemplate(object){
//   var template = '<tr>' + '</tr>'
//   return template
// }

// function clearLocalStorage(item_key){
//   localStorage.removeItem(item_key)
// }

// function fetchCachedData(key){
//   return JSON.parse( localStorage.getItem(key) )
// }
