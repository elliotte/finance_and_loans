         function Chart (api) {
              this.api = api;
              this.newBarChart = function(container) {

                  return new this.api.charts.Bar(container);

              };

              this.newDataTable = function(data) {
                  return this.api.visualization.arrayToDataTable(data);
              }
         }

         function Page (CY, PY) {
              this.cy = CY;
              this.py = PY;

              this.loadList = function(firstRow) {
                
                _list = [firstRow]
                current_yr = this.cy;
                comparative_year = this.py;

                reportingLines = []
                for(var i = 0, len = this.cy.length; i < len; i++) {
                  name = current_yr[i][0]
                  reportingLines.push(name);
                }
                for(var i = 0, len = comparative_year.length; i < len; i++) {
                  name = current_yr[i][0]
                  reportingLines.push(name);
                }

                $.each($.unique(reportingLines), function(index, reportLine) {
                    cy = totalLines(current_yr, reportLine);
                    py = totalLines(comparative_year, reportLine);
                    _list.push([ reportLine, cy, py ]);
                })

                return _list

                 function totalLines(_collection, tag) {
                  result = 0;
                  for(var i = 0, len = _collection.length; i < len; i++) {
                    if ( _collection[i][0] == tag ) {
                       result = _collection[i][1]
                    }
                  }
                  return result
                  }


              };

         }

