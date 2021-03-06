
var graphHelper = (function() {
  
      return {

          drawReportShowCharts: function(data) {

            try{ 
               var cpData = google.visualization.arrayToDataTable(data["cp"]);
               var options = {
                title: 'Current Period',
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
               
               cpDataView = convertChartColumntoString(cpData)
               var chart = new google.visualization.PieChart(document.getElementById('cp-pie-chart'));
               chart.draw(cpDataView, options);
            }
            catch(e){
              document.getElementById('cp-pie-chart').html("No CP data found")
            }
            try{
               var ppData = google.visualization.arrayToDataTable(data["pp"]);
               var options = {
                title: 'Prior Period',
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
               ppDataView = convertChartColumntoString(cpData)
               var chart = new google.visualization.PieChart(document.getElementById('pp-pie-chart'));
               chart.draw(ppDataView, options);
             }
             catch(e){
                document.getElementById('pp-pie-chart').html("No PP data found")
             }

             try{
               this.drawShowBar(data["cp"], data["pp"])
             }
             catch(e) {
               document.getElementById('show-page-bar-chart').html("No PP data found")
             }


         	},
          // BAR GRAPH CHART FOR REPORT SHOW PAGE PIE ALTERNATIVE
          drawShowBar: function(dataCY, dataPY) {

              var page = new Page(dataCY, dataPY)

              var cacheData = page.buildShowPageBarChartArrayTable();
              var barData = new google.visualization.arrayToDataTable(cacheData);
              
              var container = document.getElementById('show-page-bar-chart')
              //var assetData = new google.visualization.arrayToDataTable(dataForGoogleArrayTable);
             
              var options = {
                        height: 400,
                        title: 'Current vs Comparative analysis using ' + "your MI Tag",
                        titleTextStyle: {
                          color: '#94CFD5'
                        },
                        backgroundColor: 'none',
                        bars: 'vertical',
                        vAxis: {
                          format: 'decimal',
                          color: '#94CFD5'
                        },
                        hAxis: {
                          title: "Your MI Tag Description",
                          format: 'decimal',
                          titleTextStyle: {
                            color: '#FF8C86'
                          },
                          textStyle: {
                            color: '#ccc'
                          },
                        },
                        colors: ['#94CFD5', '#FF8C86'],
              };
              chartForAssets = new google.visualization.ColumnChart(container);

              chartForAssets.draw(barData, google.charts.Bar.convertOptions(options));
              //console.log(chartForAssets.error)

          },
           // PNL CHART FOR REPORT DASH
          drawPNLDashCharts: function(CY, PY, container) {

              var page = new Page(CY, PY)
              var parsedData = page.buildArrayTable(['Income Statement Categories', 'Current', 'Comparative'], true)
              var incomeData = new google.visualization.arrayToDataTable(parsedData)
              //var incomeData =  convertChartColumntoString(incomeData1)
              var PNLoptions = {
                height: 400,
                chart: {
                  title: 'Current vs Comparative analysis of Profit and Loss',
                  subtitle: subtitleText,
                },
                bars: 'horizontal', // Required for Material Bar Charts.
                hAxis: {format: 'decimal'},
                colors: ['#94CFD5', '#FF8C86']
              };

              var chartPNL = new google.charts.Bar(container);
              
              //google.visualization.events.addListener(chartPNL, 'error', errorHandler);
              chartPNL.draw(incomeData, google.charts.Bar.convertOptions(PNLoptions));
              console.log(chartPNL.error)
          },
          // Asset CHART FOR REPORT DASH
          drawBSAssetChart: function(dataCY, dataPY, title, container) {
                var page = new Page(dataCY, dataPY)
                firstRow = [title, 'Current', 'Comparative']
                  
                var assetData = new google.visualization.arrayToDataTable(page.buildArrayTable(firstRow));
               
                options = this.reportDashChartOptionsBS(title, subtitleText)

                chartForAssets = new google.visualization.ColumnChart(container);

                chartForAssets.draw(assetData, google.charts.Bar.convertOptions(options));
                console.log(chartForAssets.error)
          },
          // LIABS DASH SHOW REPORTS
          drawBSLiabChart: function(dataCY, dataPY, title, container) {
                var page = new Page(dataCY, dataPY)
                firstRow = [title, 'Current', 'Comparative']
                  
                var liabData = new google.visualization.arrayToDataTable(page.buildArrayTable(firstRow));
                
                options = this.reportDashChartOptionsBS(title, subtitleText)

                chartForLiabs = new google.visualization.ColumnChart(container);

                chartForLiabs.draw(liabData, google.charts.Bar.convertOptions(options));
                console.log(chartForLiabs.error)
          },  
          //CHART options for BS
          reportDashChartOptionsBS: function(title, subtitleText) {
                  var options = {
                        height: 400,
                        title: 'Current vs Comparative analysis of ' + title,
                        titleTextStyle: {
                          color: '#94CFD5'
                        },
                        backgroundColor: 'none',
                        bars: 'vertical',
                        vAxis: {
                          format: 'decimal',
                        },
                        hAxis: {
                          title: subtitleText,
                          format: 'decimal',
                          titleTextStyle: {
                            color: '#FF8C86'
                          },
                          textStyle: {
                            color: '#ccc'
                          },
                        },
                        chartArea:{left:0,width:'90%'},
                        colors: ['#94CFD5', '#FF8C86'],
                  };
                  return options
          },        
      };
      // END OF RETURN      
})();      

var convertChartColumntoString = function(data_table){
  // CONVERT FIRST COLUMN VALUE INTO STRING
 var dataView = new google.visualization.DataView(data_table);
 //Set the first column of the dataview to format as a string, and return the other column 1
 dataView.setColumns([{calc: function(data, row) { return data.getFormattedValue(row, 0); }, type:'string'}, 1]);
 return dataView
}



          // OLD CODE
          // RELATES TO LEDGERS
          // drawCharts: function(data) {

          //     if ( $('#sales-chart-timeline').length ) {
          //     // IS THEREFORE SALESLEDGER SHOWPAGE DRAW
          //         var _data = google.visualization.arrayToDataTable(data);
          //         var options = {
          //           title: 'Invoices Raised',
          //           hAxis: {title: 'Description', titleTextStyle: {color: '#FFB5B1'}},
          //           legend: {position: "none" },
          //           colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
          //         }

          //         var chartT = new google.visualization.ColumnChart(document.getElementById('sales-chart-timeline'));
          //         chartT.draw(_data, options);

          //     } else {
          //     // IS THEREFORE CASHLEDGER SHOWPAGE DRAW
          //       var pData = google.visualization.arrayToDataTable(data["Payments"]);
          //       var options = {
          //         title: '% of total',
          //         is3D: true,
          //         legend: {position: "none" },
          //         colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
          //       };
          //       var chart = new google.visualization.PieChart(document.getElementById('payment-pie-chart'));
          //       chart.draw(pData, options);

          //       var dataLodgements = google.visualization.arrayToDataTable(data["Lodgements"]);
          //       var optionsL = {
          //         title: '% of total',
          //         is3D: true,
          //         legend: {position: "none" },
          //         colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
          //       };
          //       var chartL = new google.visualization.PieChart(document.getElementById('lodgement-pie-chart'));
          //       chartL.draw(dataLodgements, optionsL);
          //       // var dataT = google.visualization.arrayToDataTable(last3monthsTransactions);
          //       var dataT = google.visualization.arrayToDataTable(data["Timeline"]);

          //       var optionsT = {
          //           title: 'Timeline',
          //           hAxis: {title: 'Description', titleTextStyle: {color: '#FFB5B1'}},
          //           legend: {position: "none" },
          //           colors: ['#FFB5B1', '#FF8C86', '#F3655E', '#95D0D5', '#5FABB2', '#C8F17F', '#DCF7AC'],
          //       }

          //       var chartT = new google.visualization.ColumnChart(document.getElementById('columnchart_values'));
          //       chartT.draw(dataT, optionsT);
              

          //     }

          // },
