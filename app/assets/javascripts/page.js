
function Page (CY, PY) {
    
    this.cy = CY;
    this.py = PY;

    this.buildArrayTable = function(firstRow, PNL) {
      
      if (PNL) {
          
          var dataForGoogleArrayTable = [ 
              firstRow,
              ['Gross profit revenue', (sumAmts(CY.gp_rev)), (sumAmts(PY.gp_rev)) ],
              ['Gross profit COS', (sumAmts(CY.gp_cos)), (sumAmts(PY.gp_cos)) ],
              ['Operating profit revenue', (sumAmts(CY.op_rev)), (sumAmts(PY.op_rev)) ],
              ['Operating profit COS', (sumAmts(CY.op_cos)), (sumAmts(PY.op_cos)) ],
              ['Sum of tax paid', (sumAmts(CY.tax)), (sumAmts(PY.tax)) ]
          ]

      } else {

          dataForGoogleArrayTable = [firstRow]
          
          current_yr = this.cy;
          comparative_year = this.py;

          reportingLines = []

          for(var i = 0, len = current_yr.length; i < len; i++) {
            name = current_yr[i][0]
            reportingLines.push(name);
          }
          for(var i = 0, len = comparative_year.length; i < len; i++) {
            name = comparative_year[i][0]
            reportingLines.push(name);
          }
          $.each($.unique(reportingLines), function(index, reportLine) {
              cy = totalLines(current_yr, reportLine);
              py = totalLines(comparative_year, reportLine);
              dataForGoogleArrayTable.push([ reportLine, cy, py ]);
          })

      }
        if(dataForGoogleArrayTable.length==1)
        {dataForGoogleArrayTable.push([0,0,0])} 
      return dataForGoogleArrayTable
                  //helper functionMETHOD for buildLIST
                  function totalLines(_collection, tag) {
                          result = 0;
                          for(var i = 0, len = _collection.length; i < len; i++) {
                            if ( _collection[i][0] == tag ) {
                               result = _collection[i][1]
                            }
                          }
                          return parseInt(result)
                  }
                  // END OF HELPER
                  //HELPER FOR TOTALLING PNL LINES
                  function sumAmts(collection) {
                          var sumOf = 0; 
                          for(var i = 0, len = collection.length; i < len; i++) {
                              amt = parseInt(collection[i][1])
                              sumOf += amt;  
                          }
                          return parseFloat(sumOf)
                  }
                  // END OF HELPER

    };
    // END OF buildArrayTable

}

