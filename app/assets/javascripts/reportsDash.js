$(document).on('page:load ready', function(){
         // end of values breakdown
         // cache graph data
         var dashData = ifrsDashShow.loadData();
         // LOAD MARGIN STATISTICS
         ifrsDashShow.loadStats();
         // DRAW GOOGLE CHARTS
         format = $('#dash-report-format').data('value')
         subtitleText = 'Using '+ format +' classifications';

         (function() {
            graphHelper.drawIncomeStatCharts(dashData.cy, dashData.py);
         })(); 

         (function() {
            graphHelper.drawLiabCharts(dashData.cy.liabs, dashData.py.liabs);
         })(); 
         
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
