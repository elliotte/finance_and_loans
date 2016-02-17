
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
         
         uiSharedHelper.setAccordianHandlers(); 
         // DATA LISTENERS
         // FETCH DATA LISTENERS 
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
         // END OF DATA LISTENERS
};
// END OF READY

$(document).ready(ready);
$(document).on('page:load', ready);

var ifrsDashShow = (function() {

      return {

          cacheData: function() {
            var data = {
              cy: {
                gp_rev: [],
                gp_cos: [],
                op_rev: [],
                op_cos: [],
                tax: [],
                assets: [],
                liabs: []
              },
              py: {
                gp_rev: [],
                gp_cos: [],
                op_rev: [],
                op_cos: [],
                tax: [],
                assets: [],
                liabs: []
              },
            }
            // END OF DATA
            var fsReportingLines = $('.js-fs-line')
            $.each(fsReportingLines, function(index, repLine) {

              tag = $(repLine).data('tag')
              lineDescription = $(repLine).data('reporting-line')
              cy_amt = $(repLine).data('cy')
              py_amt = $(repLine).data('py')
              cy_info = [ lineDescription , cy_amt ]
              py_info = [ lineDescription, py_amt ]

              switch (tag) {
                // PNL GAAP AND IFRS
                  case "gp-rev":
                      data.cy.gp_rev.push(cy_info)
                      data.py.gp_rev.push(py_info)
                      break;
                  case "gp-cos":
                      data.cy.gp_cos.push(cy_info)
                      data.py.gp_cos.push(py_info)
                      break;
                  case "op-rev":
                      data.cy.op_rev.push(cy_info)
                      data.py.op_rev.push(py_info)
                      break;
                  case "op-cos":
                      data.cy.op_cos.push(cy_info)
                      data.py.op_cos.push(py_info)
                      break;
                  case "pbt-cos":
                      data.cy.tax.push(cy_info)
                      data.py.tax.push(py_info)
                      break;
                  case "tax":
                      data.cy.tax.push(cy_info)
                      data.py.tax.push(py_info)
                      break;
                // ASSETS GAAP
                  case "fa_tang":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
                      break;
                  case "fa_intang":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
                      break;
                  case "curr_assets":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
                      break;
                // ASSETS IFRS
                  case "ca":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
                      break;
                   case "nca":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
                      break;
                  case "assets":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
                      break;
                // CREDITORS n EQUITY GAAP
                  case "cred_current":
                      data.cy.liabs.push(cy_info)
                      data.py.liabs.push(py_info)
                      break;
                  case "cred_greater":
                      data.cy.liabs.push(cy_info)
                      data.py.liabs.push(py_info)
                      break;
                  case "capital":
                      data.cy.liabs.push(cy_info)
                      data.py.liabs.push(py_info)
                      break;
                //CREDITORS n EQUTY IFRS
                  case "ncl":
                      data.cy.liabs.push(cy_info)
                      data.py.liabs.push(py_info)
                      break;
                  case "cl":
                      data.cy.liabs.push(cy_info)
                      data.py.liabs.push(py_info)
                      break;
                  case "liabs":
                      data.cy.liabs.push(cy_info)
                      data.py.liabs.push(py_info)
                      break;
              }
              // END OF SWITCH
            });
            // END OF EACH
            return data
          },

          loadStats: function() {

              gpData = [$('#js-gp-margin-data'), $('#js-op-margin-data'), $('#js-margin-data') ]

              cy_statsViewList = $('#cy-p-n-l-stats')
              py_statsViewList = $('#py-p-n-l-stats')

              $.each(gpData, function(index, stat) {

                  statText = $(stat).attr('id')
                  displayText = "";

                  switch (statText) {
                    case "js-gp-margin-data":
                        displayText = "GP Margin";
                        break;
                    case "js-op-margin-data":
                        displayText = "OP Margin";
                        break;
                    case "js-margin-data":
                        displayText = "Profit Margin";
                        break;
                  }

                  cy_html = '<li>' +
                              $(stat).data('cy') +
                              '<span>' + displayText + '</span>' +
                            '</li>'
                  py_html = '<li>' +
                              $(stat).data('py') +
                              '<span>' + displayText + '</span>' +
                            '</li>'
                  $(cy_statsViewList).append(cy_html)
                  $(py_statsViewList).append(py_html)

              });

          },
          // END OF LOAD STATS
          loadData: function() {
             var dashPageData = this.cacheData();
             return dashPageData
          },

          exportDashGoogle: function() {
            // Common fetch data
            var data = fetchData();
            var token = $("meta[name='csrf-token']").attr("content");
            var request = new XMLHttpRequest();
            request.onload = successDashExport;
            // request.onerror = errorDisplay;
              request.open("post", '/reports/' + $('#report-id').val() + '/export_dash', true );
              request.setRequestHeader("Content-Type", "application/json");
              request.setRequestHeader("X-CSRF-Token", token);
              request.send(JSON.stringify(data));

          },

      };
      // END OF RETURN

})();

function successDashExport() {
  $('#bg-screen-for-modal').addClass('open')
  
    response = this.responseText
    if (response.indexOf("ERROR") > -1) {
      html = '<article class="type-system-slab">' + '<p>' + 'ERROR' + '</p>' +
             '<a href="/" data-no-turbolinks=true>' + 'RECONNECT' + '</a>' + '</article>'
    } else {
      link = '<a href="'+response+'" target="_blank">' + 'VIEW' + '</a>'
      html = '<article class="type-system-slab">' + '<p>' + 'Successful Export: ' + link + '</p>' + '</article>'
    }
    $('#bg-screen-for-modal').find('section').empty().html(html) 
};

function fetchData(){
  var fsReportingLines = $('.js-fs-line')
  var data = []
  $.each(fsReportingLines, function(index, repLine) {

    tag = $(repLine).data('tag')
    lineDescription = $(repLine).data('reporting-line')
    cy_amt = $(repLine).data('cy')
    py_amt = $(repLine).data('py')
    row = [ lineDescription , cy_amt, py_amt, tag ]
    data.push(row)

  });
  return data
};

function exportDashOffice(){
  var data =fetchData();

  $.ajax({
    url: '/reports/' + $('#report-id').val() + '/export_dash_o365',
    type: "POST",
    //dataType: 'json',
    data:{ 
      csv: JSON.stringify(data)}         
    })
};
