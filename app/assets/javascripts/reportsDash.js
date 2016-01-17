var ready;

ready = function() {
         // Cache Graph data FROM DOM
         var dashData = ifrsDashShow.loadData();
         // LOAD MARGIN STATISTICS
         ifrsDashShow.loadStats();
         format = $('#dash-report-format').data('value')
         subtitleText = 'Using '+ format +' classifications';
         // DRAW GOOGLE CHARTS DASH SHOW
         //PNL
         try {
            var CY = dashData.cy
            var PY = dashData.py
            graphHelper.drawPNLDashCharts(CY,PY, document.getElementById("income-statement-graph"));
         } catch (e) {
            console.log(e); // pass exception object to error handler
         }
         //Assets
         try {
           var CY = dashData.cy.assets
           var PY = dashData.py.assets
           graphHelper.drawBSAssetChart(CY,PY, "Company assets", document.getElementById("assets-graph") );
         } catch (e) {
           console.log(e); // pass exception object to error handler
         }
         //LIABSs
         try {
           var CY = dashData.cy.liabs
           var PY = dashData.py.liabs
           graphHelper.drawBSLiabChart(CY,PY, "Company liabilities", document.getElementById("liabs-graph") );
         } catch (e) {
           console.log(e); // pass exception object to error handler
         }
         
};

$(document).ready(ready);
$(document).on('page:load', ready);

$(document).on('page:load ready', function() {

         $('.fs-scroll').on('click', function(e) {
                   e.preventDefault();
                   anchor = $(this).data('anchor')
                   var top = $('#' + anchor).offset().top - 50
                   $('html, body').animate({ scrollTop: top }, 1500)
         });

         $('.values_breakdown').on('click', function(){
             range = $(this).attr('data-period')
             lineTag = $(this).attr('data-ifrstag')
             summary = $(this).data('summary-line')
             if (summary) {
                summaryTag = $(this).data('summary-tag')
                _data = {"ifrstag" : lineTag, "period" : range, "summary" : summaryTag }
              } else {
                _data = {"ifrstag" : lineTag, "period" : range }
             }
             $.ajax({
                url: '/reports/' + $('#report-id').val() + '/get_breakdown_values',
                dataType: 'SCRIPT',
                type: 'GET',
                data: _data
             })
          })

 });        




