$(document).on('page:load ready', function() {

         // cache graph data
         var dashData = ifrsDashShow.loadData();
         // LOAD MARGIN STATISTICS
         ifrsDashShow.loadStats();
         // DRAW GOOGLE CHARTS
         format = $('#dash-report-format').data('value')
         subtitleText = 'Using '+ format +' classifications';

         try {

           var CY = dashData.cy.assets
           var PY = dashData.py.assets
           graphHelper.drawAssetStatCharts(CY,PY);

           // function draw1() {
              
           //    var incomeData = new google.visualization.arrayToDataTable([
           //      ['Income Statement Categories', 'Current', 'Comparative'],
           //      ['Gross profit revenue', sumAmts(CY.gp_rev), sumAmts(PY.gp_rev) ],
           //      ['Gross profit COS', sumAmts(CY.gp_cos), sumAmts(PY.gp_cos) ],
           //      ['Operating profit revenue', sumAmts(CY.op_rev), sumAmts(PY.op_rev) ],
           //      ['Operating profit COS', sumAmts(CY.op_cos), sumAmts(PY.op_cos) ],
           //      ['Sum of tax paid', sumAmts(CY.tax), sumAmts(PY.tax) ],
           //    ]);
           //    console.log(incomeData)
           //    var PNLoptions = {
           //      height: 400,
           //      chart: {
           //        title: 'Current vs Comparative analysis of Profit and Loss',
           //        subtitle: subtitleText,
           //      },
           //      bars: 'horizontal', // Required for Material Bar Charts.
           //      hAxis: {format: 'decimal'},
           //      colors: ['#94CFD5', '#FF8C86']
           //    };

           //    var chartPNL = new google.charts.Bar(document.getElementById("income-statement-graph"));
           //    chartPNL.draw(incomeData, google.charts.Bar.convertOptions(PNLoptions));
           //    console.log(chartPNL.error)

           // }

           //google.setOnLoadCallback(draw2);

         } catch (e) {

           console.log(e); // pass exception object to error handler

         }

         try {

             var CY = dashData.cy
             var PY = dashData.py
             graphHelper.drawIncomeStatCharts(CY,PY);

         } catch (e) {
          console.log(e); // pass exception object to error handler

         }

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




