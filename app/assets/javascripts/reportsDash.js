
$(document).on('page:load ready', function(){
         // end of values breakdown
         // cache graph data
         var dashData = ifrsDashShow.loadData();
         // LOAD MARGIN STATISTICS
         ifrsDashShow.loadStats();
         // DRAW GOOGLE CHARTS
         format = $('#dash-report-format').data('value')
         subtitleText = 'Using '+ format +' classifications';

         try {

           google.setOnLoadCallback(graphHelper.drawIncomeStatCharts(dashData.cy, dashData.py));
           //google.setOnLoadCallback(graphHelper.drawAssetStatCharts(dashData.cy.assets, dashData.py.assets));

         } catch (e) {

           console.log(e); // pass exception object to error handler

         }
         //graphHelper.drawLiabCharts(dashData.cy.liabs, dashData.py.liabs);

         var builder = new Page(dashData.cy.liabs, dashData.py.liabs);
         firstRow = ['Company Liabilities', 'Current', 'Comparative']
         
         var _data = builder.loadList(firstRow)
         var _chart = new Chart(google);

         var liabData = _chart.newDataTable(_data)

         var liabOptions = {
            height: 400,
            chart: {
              title: 'Current vs Comparative analysis of liabilities',
              subtitle: subtitleText,
            },
            colors: ['#94CFD5', '#FF8C86']
          };
         console.log(liabData)

         newBarLiabs = _chart.newBarChart(document.getElementById("liabs-graph"))
         builder.draw(newBarLiabs, liabData, google.charts.Bar.convertOptions(liabOptions))

         //graphHelper.loadStats(stats)
         $('.fs-scroll').on('click', function(e) {
           e.preventDefault();
           anchor = $(this).data('anchor')
           var top = $('#' + anchor).offset().top - 50
           $('html, body').animate({ scrollTop: top }, 1500)
         });

         $(document).on('click', '.values_breakdown', function(){
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
  // END OF PAGELOAD READY


