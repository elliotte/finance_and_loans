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
              slices: {  4: {offset: 0.2},
                    12: {offset: 0.3},
                    14: {offset: 0.4},
                    19: {offset: 0.5},
                    24: {offset: 0.6},
              },
              sliceVisibilityThreshold: .001,
              colors: ['#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC', '#FFB5B1', '#FF8C86', '#F3655E',],
             };

             var chart = new google.visualization.PieChart(document.getElementById('cp-pie-chart'));
             chart.draw(cpData, options);

             var ppData = google.visualization.arrayToDataTable(data["pp"]);
             var options = {
              title: 'Prior values by your tag',
              is3D: true,
              legend: {position: "none" },
              slices: {  4: {offset: 0.2},
                    12: {offset: 0.3},
                    14: {offset: 0.4},
                    19: {offset: 0.5},
                    24: {offset: 0.6},
              },
              sliceVisibilityThreshold: .001,
              colors: ['#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC', '#FFB5B1', '#FF8C86', '#F3655E',],
             };

             var chart = new google.visualization.PieChart(document.getElementById('pp-pie-chart'));
             chart.draw(ppData, options);

          },

          drawIncomeStatCharts: function(CY, PY) {

            try {
                if ($("#income-statement-graph").length) { 
                    var incomeData = google.visualization.arrayToDataTable([
                      ['Income Statement Categories', 'Current', 'Comparative'],
                      ['Gross profit revenue', sumAmts(CY.gp_rev), sumAmts(PY.gp_rev) ],
                      ['Gross profit COS', sumAmts(CY.gp_cos), sumAmts(PY.gp_cos) ],
                      ['Operating profit revenue', sumAmts(CY.op_rev), sumAmts(PY.op_rev) ],
                      ['Operating profit COS', sumAmts(CY.op_cos), sumAmts(PY.op_cos) ],
                      ['Sum of tax paid', sumAmts(CY.tax), sumAmts(PY.tax) ],
                    ]);
                    console.log(incomeData)
                    var PNLoptions = {
                      height: 400,
                      chart: {
                        title: 'Current vs Comparative analysis of Profit and Loss',
                        subtitle: subtitleText,
                      },
                      colors: ['#94CFD5', '#FF8C86']
                    };

                    var chartPNL = new google.charts.Bar(document.getElementById("income-statement-graph"));
                    chartPNL.draw(incomeData, PNLoptions);
                    console.log(chartPNL.error)
                };
              }
              catch (e) {
                 console.log(e); // pass exception object to error handler
              }

          },

          drawAssetStatCharts: function(dataCY, dataPY) {
            
            // format = $('#dash-report-format').data('value')
            // subtitleText = 'Using '+ format +' classifications'

            //  try {
            //       if ($("#assets-graph").length) { 
            //           dataList = [
            //               ['Company assets', 'Current', 'Comparative'],
            //           ]
            //           cy_assets = dataCY
            //           py_assets = dataPY
            //           cyAssetLines = getReportingLines( cy_assets )
            //           pyAssetLines = getReportingLines( py_assets )
            //           assetLines = cyAssetLines.concat(pyAssetLines)

            //           buildBalSheetDataList(assetLines, cy_assets, py_assets);
            //           console.log(dataList)
            //           var graphData = google.visualization.arrayToDataTable(dataList);
            //           console.log(graphData)
            //           var options = {
            //             height: 400,
            //             chart: {
            //               title: 'Current vs Comparative analysis of assets',
            //               subtitle: subtitleText,
            //             },
            //             colors: ['#94CFD5', '#FF8C86']
            //           };
            //           var chart = new google.charts.Bar(document.getElementById("assets-graph"));
            //           chart.draw(graphData, options);
            //           console.log(chart.error)
            //       }        


            //  }
            //  catch (e) {
            //     console.log(e); // pass exception object to error handler
            //  }

          },

          drawLiabCharts: function(CY, PY) {
          // LIABS DASH SHOW REPORTS
            if ($("#liabs-graph").length) { 
                dataListLiabs = [
                    ['Company Liabilities', 'Current', 'Comparative'],
                ]
                cy_liabs = CY
                py_liabs = PY

                cyLiabsLines = getReportingLines( cy_liabs )
                pyLiabsLines = getReportingLines( py_liabs )
                liabLines = cyLiabsLines.concat(pyLiabsLines)
                
                var dataListLiabs = buildBalSheetDataList(liabLines, cy_liabs, py_liabs, dataListLiabs);
                console.log(dataListLiabs)

                var graphDataLiabs = google.visualization.arrayToDataTable(dataListLiabs);
                console.log(graphDataLiabs)
                var options = {
                  height: 400,
                  chart: {
                    title: 'Current vs Comparative analysis of liabilities',
                    subtitle: subtitleText,
                  },
                  colors: ['#94CFD5', '#FF8C86']
                };
                var chartLiabs = new google.charts.Bar(document.getElementById("liabs-graph"));
                chartLiabs.draw(graphDataLiabs, options);
                console.log(chartLiabs.error)
            }

          },  
          // END OF DRAW FS CHART

      };
      // END OF RETURN
})();

 // DRAWFSCHART HELPERS
              function buildBalSheetDataList(reportingLines, current_yr, comparative_year, dataList) {
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
