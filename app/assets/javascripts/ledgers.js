var ready;
ready = function() {

	var show_page_data = cashLedgerShow.loadData();
	graphHelper.drawCharts(show_page_data);
  cashLedgerShow.setSummaryModals();

};

$(document).ready(ready);
$(document).on('page:load', ready);

$(document).on('page:load ready', function(){
  $(document).on('click', '#next-20-button', function(){
    $.ajax({
      url: '/cash_ledgers/' + $(this).attr('data-report-id') + '/next_transactions',
      data: {"offset" : $(this).attr('data-offset')},
      method: 'GET',
      dataType: 'SCRIPT'
    })
  })
})


