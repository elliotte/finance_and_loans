
var graphHelper = (function() {
  
      return {

          drawCharts: function(data) {

              if ( $('#sales-chart-timeline').length ) {
              // IS THEREFORE SALESLEDGER SHOWPAGE DRAW
                  var _data = google.visualization.arrayToDataTable(data);
                  var options = {
                    title: 'Invoices Raised',
                    hAxis: {title: 'Description', titleTextStyle: {color: '#FFB5B1'}},
                    legend: {position: "none" },
                    colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
                  }

                  var chartT = new google.visualization.ColumnChart(document.getElementById('sales-chart-timeline'));
                  chartT.draw(_data, options);

              } else {
              // IS THEREFORE CASHLEDGER SHOWPAGE DRAW
                var pData = google.visualization.arrayToDataTable(data["Payments"]);
                var options = {
                  title: '% of total',
                  is3D: true,
                  legend: {position: "none" },
                  colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
                };
                var chart = new google.visualization.PieChart(document.getElementById('payment-pie-chart'));
                chart.draw(pData, options);

                var dataLodgements = google.visualization.arrayToDataTable(data["Lodgements"]);
                var optionsL = {
                  title: '% of total',
                  is3D: true,
                  legend: {position: "none" },
                  colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
                };
                var chartL = new google.visualization.PieChart(document.getElementById('lodgement-pie-chart'));
                chartL.draw(dataLodgements, optionsL);
                // var dataT = google.visualization.arrayToDataTable(last3monthsTransactions);
                var dataT = google.visualization.arrayToDataTable(data["Timeline"]);

                var optionsT = {
                    title: 'Timeline',
                    hAxis: {title: 'Description', titleTextStyle: {color: '#FFB5B1'}},
                    legend: {position: "none" },
                    colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
                }

                var chartT = new google.visualization.ColumnChart(document.getElementById('columnchart_values'));
                chartT.draw(dataT, optionsT);
              

              }

          },

          drawDashCharts: function(data) {
            var cyData = google.visualization.arrayToDataTable(data["cy"]);
            var options = {
              title: 'Income statement analysis',
              is3D: true,
              colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
            };
            var chart = new google.visualization.PieChart(document.getElementById('cy-pie-chart'));
            chart.draw(cyData, options);

            var pyData = google.visualization.arrayToDataTable(data["py"]);
            var options = {
              title: 'Income statement analysis',
              is3D: true,
              colors: ['#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC', '#FFB5B1', '#FF8C86', '#F3655E',],
            };
            var chart = new google.visualization.PieChart(document.getElementById('py-pie-chart'));
            chart.draw(pyData, options);

          },

          drawReportShowCharts: function(data) {
            
             var cpData = google.visualization.arrayToDataTable(data["cp"]);
             var options = {
              title: 'Current values by your tag',
              is3D: true,
              legend: {position: "none" },
              colors: ['#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC', '#FFB5B1', '#FF8C86', '#F3655E',],
             };
             console.log(data["cp"])

             $.each(data["cp"], function(index, repLine) {
              tag = $(repLine[0])
              amt = $(repLine[0][1])
              console.log([repLine[0], repLine[1], tag, amt])
             });

             var chart = new google.visualization.PieChart(document.getElementById('cp-pie-chart'));
             chart.draw(cpData, options);

             var ppData = google.visualization.arrayToDataTable(data["pp"]);
             var options = {
              title: 'Prior values by your tag',
              is3D: true,
              legend: {position: "none" },
              colors: ['#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC', '#FFB5B1', '#FF8C86', '#F3655E',],
             };

             var chart = new google.visualization.PieChart(document.getElementById('pp-pie-chart'));
             chart.draw(cpData, options);

          },

          drawFSCharts: function(data) {
            
            format = $('#dash-report-format').data('value')
            subtitleText = 'Using '+ format +' classifications'
    // INCOME STATEMENT
            if ($("#income-statement-graph").length) { 
                graphContainer = document.getElementById("income-statement-graph")
                var graphData = google.visualization.arrayToDataTable([
                  ['Income Statement Categories', 'Current', 'Comparative'],
                  ['Gross profit revenue', sumAmts(data.cy.gp_rev), sumAmts(data.py.gp_rev) ],
                  ['Gross profit COS', sumAmts(data.cy.gp_cos), sumAmts(data.py.gp_cos) ],
                  ['Operating profit revenue', sumAmts(data.cy.op_rev), sumAmts(data.py.op_rev) ],
                  ['Operating profit COS', sumAmts(data.cy.op_cos), sumAmts(data.py.op_cos) ],
                  ['Sum of tax paid', sumAmts(data.cy.tax), sumAmts(data.py.tax) ],
                ]);

                var options = {
                  height: 400,
                  chart: {
                    title: 'Current vs Comparative analysis of Profit and Loss',
                    subtitle: subtitleText,
                  },
                  colors: ['#94CFD5', '#FF8C86']
                };

                var chart = new google.charts.Bar(graphContainer);
                chart.draw(graphData, options);
            };
      // ASSETS
            if ($("#assets-graph").length) { 
                graphConatiner = document.getElementById("assets-graph")
                dataList = [
                    ['Company assets', 'Current', 'Comparative'],
                ]
                cy_assets = data.cy.assets
                py_assets = data.py.assets
                cyAssetLines = getReportingLines( cy_assets )
                pyAssetLines = getReportingLines( py_assets )
                assetLines = cyAssetLines.concat(pyAssetLines)

                buildBalSheetDataList(assetLines, cy_assets, py_assets);
                
                var graphData = google.visualization.arrayToDataTable(dataList);
                var options = {
                  height: 400,
                  chart: {
                    title: 'Current vs Comparative analysis of assets',
                    subtitle: subtitleText,
                  },
                  colors: ['#94CFD5', '#FF8C86']
                };
                var chart = new google.charts.Bar(graphConatiner);
                chart.draw(graphData, options);
            }        
      // LIABS
            if ($("#liabs-graph").length) { 
                graphConatiner = document.getElementById("liabs-graph")
                dataList = [
                    ['Company Liabilities', 'Current', 'Comparative'],
                ]
                cy_liabs = data.cy.liabs
                py_liabs = data.py.liabs

                cyLiabsLines = getReportingLines( cy_liabs )
                pyLiabsLines = getReportingLines( py_liabs )
                liabLines = cyLiabsLines.concat(pyLiabsLines)

                buildBalSheetDataList(liabLines, cy_liabs, py_liabs);

                var graphData = google.visualization.arrayToDataTable(dataList);
                var options = {
                  height: 400,
                  chart: {
                    title: 'Current vs Comparative analysis of liabilities',
                    subtitle: subtitleText,
                  },
                  colors: ['#94CFD5', '#FF8C86']
                };
                var chart = new google.charts.Bar(graphConatiner);
                chart.draw(graphData, options);
            }
        // DRAWFSCHART HELPERS
              function buildBalSheetDataList(reportingLines, current_yr, comparative_year) {
                 $.each($.unique(reportingLines), function(index, reportLine) {
                    cy = getLineAmt(current_yr, reportLine);
                    py = getLineAmt(comparative_year, reportLine);
                    dataForGraph = [
                      reportLine, cy, py
                    ]
                    dataList.push(dataForGraph);
                  })
                 return dataList
              }
              function getLineAmt(collection, tag) {
                  result = 0;
                  for(var i = 0, len = collection.length; i < len; i++) {
                    if ( collection[i][0] == tag ) {
                       result = collection[i][1]
                    }
                  }
                  return result
              }
              function getReportingLines(collection) {
                  reportingLines = []
                  for(var i = 0, len = collection.length; i < len; i++) {
                    name = collection[i][0]
                    reportingLines.push(name);
                  }
                  return reportingLines
              }
              function sumAmts(collection) {
                var sumOf = 0; 
                for(var i = 0, len = collection.length; i < len; i++) {
                    amt = parseInt(collection[i][1])
                    sumOf += amt;  
                }
                return sumOf
              }
          },  
          // END OF DRAW FS CHART

      };
      // END OF RETURN
})();


