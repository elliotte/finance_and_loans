
var reportHelper = (function() {
      var showPageData = {
          'cp' : "",
          'pp' : "",
      }
      // FOR ADD JOURNALS FORM
      var values_index = 2;

      return {

        filterBy: function(info) {

          filterVariable = info.value
          filterFormat = $(info).attr('id')

          all_values = $('.trn-report-mgr')

          switch (filterFormat) {
            case "v_type":
                filterValues('type');
                break;
            case "v_month":
                filterValues('month');
                break;
            case "ifrstag":
                filterValues('ifrstag');
                break;
          }
          // END OF SWITCH

          // START HELPER FUNCTION
          function filterValues(format) {

              $.each(all_values, function(i, value) {

                valueID = $(value).data('value-id')
                rowHandler = 'tr#' + valueID
                valueProp = $(value).data(format)

                if (valueProp == filterVariable) {
                  $(rowHandler).show()
                } else {
                  $(rowHandler).hide()
                }

              });

          }
          // END OF HELPER FUNCTION
        },

        loadValuesByMiTag: function(line, tag_type, period) {
            lineDescription = $(line).data('mitag')
            allValues = $('.'+ tag_type + '_' + lineDescription)
            var keep = period;

            allValues = $.grep(allValues, function(value) {
              period = $(value).data('period')
              return period == keep;
            });
            reportHelper.appendModalShowPageValues(allValues)
        },

        loadValuesByDescription: function(line, period) {
           lineDescription = $(line).data('description')

           allValues = $('.value-lookup')
           var keep = period;

           showValues = $.grep(allValues, function(value) {
              period = $(value).data('period')
              jsDesc = $(value).data('desc')
              return period == keep && jsDesc == lineDescription;
           });

           reportHelper.appendModalShowPageValues(showValues)
        },

        loadJournalValues: function(line, period) {
           lineDescription = $(line).data('description')

           allValues = $('[class^="etb"]')
           
           var keep = period;
           showValues = $.grep(allValues, function(value) {
              period = $(value).data('period')
              jsDesc = $(value).data('desc')
              return period == keep && jsDesc == lineDescription;
           });

           reportHelper.appendModalShowPageValues(showValues)
        },

        appendModalShowPageValues: function(values) {

            body = $('#empty-modal-table')
            title = $('#table-title')
            body.empty();
            title.empty();

            $('#modal-table-empty').trigger('click')

            header = '<tr style="color:#f3655e;">' +
                            '<td>' + 'Type' +'</td>' +
                            '<td>' + 'Date' + '</td>' +
                            '<td>' + 'miTag' + '</td>' +
                            '<td>' + '£' + '</td>' +
                            '<td>' + 'moneaTag' + '</td>' +
                      '</tr>'

            body.append(header)

            $.each(values, function(i, tag){
               html = '<tr>' +
                            '<td>' +
                              $(tag).data('type') +
                            '</td>' +
                            '<td>' +
                              $(tag).data('date') +
                            '</td>' +
                            '<td>' +
                              $(tag).data('mitag') +
                            '</td>' +
                            '<td>' +
                              $(tag).data('amount') +
                            '</td>' +
                            '<td>' +
                              $(tag).data('ifrstag') +
                            '</td>' +
                      '</tr>'
               body.append(html)

            });
            title.append('<p style="color:#f3655e;">' + ' Summary: ' + lineDescription + '</p>')

        },

        // END OF LOAD VALUES SUMMARY
        loadShowPageData: function() {

            var repShowData = {
              'cp': "",
              'pp': "",
           };

           all_cy_RepLines = $('.cy-graph-rep-lines')
           data =[['yourTag','Amount']]

           $.each(all_cy_RepLines, function(index, repLine) {
              tag = $(repLine).data('key')
              amt = $(repLine).data('amount')

              if(typeof tag !== "undefined" && typeof amt !== "undefined") {
                data.push([tag, amt])
              }

           });

           repShowData['cp'] = data
           all_pp_RepLines = $('.pp-graph-rep-lines')

           data =[['yourTag','Amount']]

           $.each(all_cy_RepLines, function(index, repLine) {
              tag = $(repLine).data('key')
              amt = $(repLine).data('amount')
              if(typeof tag !== "undefined" && typeof amt !== "undefined") {
                data.push([tag, amt])
              }
           });
           repShowData["pp"] = data
           console.log(repShowData)
           return repShowData

        },
        // END OF LOAD CACHE SHOW PAGE DATA
        drawCharts: function(data) {
           graphHelper.drawReportShowCharts(data);
        },

        addValueToJournalForm: function() {
            if(values_index > 30){
              alert('Only 30 Values allowed');
            } else {
              var template = $('.value_template tbody').html();
              template = template.replace(/index/g, values_index);
              $('.etb_values tbody').append(template);
              values_index++;
            }
        },
        // END OF DRAW CHARTS FUNCTION
      };
      // END OF RETURN
})();

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
                  case "tax":
                      data.cy.tax.push(cy_info)
                      data.py.tax.push(py_info)
                      break;
                  case "assets":
                      data.cy.assets.push(cy_info)
                      data.py.assets.push(py_info)
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

            var token = $("meta[name='csrf-token']").attr("content");
            var request = new XMLHttpRequest();
              request.onload = successDashExport;
//              request.onerror = errorDisplay;

              request.open("post", '/reports/' + $('#report-id').val() + '/export_dash', true );
              request.setRequestHeader("Content-Type", "application/json");
              request.setRequestHeader("X-CSRF-Token", token);
              request.send(JSON.stringify(data));

          },

      };
      // END OF RETURN

})();

var etbHelper = (function() {

  return {
      cacheData: function() {

          jnlNumbers = $('.etb-jnl-headers')
          reportingLines = $('.reporting-line')
          console.log(jnlNumbers)
          console.log(reportingLines)

      }
  };

})();

function successDashExport() {
    $('#modal-report-dash-empty').trigger('click');
    response = this.responseText
    if (response.indexOf("ERROR") > -1) {
      html = '<article class="type-system-rounded">' + '<p>' + 'ERROR' + '</p>' +
             '<a href="/" data-no-turbolinks=true>' + 'RECONNECT' + '</a>' + '</article>'
    } else {
      link = '<a href="'+response+'" target="_blank">' + 'VIEW' + '</a>'
      html = '<article class="type-system-rounded">' + '<p>' + 'Successful Export: ' + link + '</p>' + '</article>'
    }
    $('#empty-report-modal-body').html(html)
};

function showReportShareModal(){

  $('#empty-modal-table').empty();
  $('#table-title').empty();

  $('#modal-table-empty').trigger('click')

  friends = JSON.parse(localStorage.getItem("friends")).items
  link = '<a href="javascript:void(0)" onclick="shareReport(this)" style="text-decoration:none;color:#94CFD5;">' + 'Share' + '</a>'
  $('#empty-modal-table').append('<p style="color:#F3655E;font-size:80%;">' + 'You can search your friends list using the browser CTRL + F feature' + '</p>')
  $.each(friends, function(index, person) {
    imgSrc = person.image.url
    html = '<tr id="' + person.id + '">' +
        '<td>' + '<img src="' + imgSrc + '" >' + '</td>' +
        '<td>' + person.displayName + '</td>' +
        '<td>' + link + '</td>' +
    '</tr>'
    $('#empty-modal-table').append(html);

  });
}

function shareReport(obj){
  shareUserID = obj.parentNode.parentNode.getAttribute('id');

  var token = $("meta[name='csrf-token']").attr("content");
  reportId = $('#report-id').val();

  var request = new XMLHttpRequest();
  request.onload = shareSuccess;
  //request.onerror = errorDisplay;
  data = {
    userID: shareUserID,
  }
  route = '/reports/' + reportId + '/share'
  console.log(route)
  request.open("put", route, true );
  request.setRequestHeader("Content-Type", "application/json");
  request.setRequestHeader("X-CSRF-Token", token);
  request.send(JSON.stringify(data));
}

function cacheNotes(reportId){
  $.ajax({
    url: '/reports/' + reportId + '/get_notes',
    dataType: 'JSON',
    type: 'GET',
    success: function(response){
      localStorage.setItem('notes', JSON.stringify(response))
      showNotes()
    }
  })
}

function cacheComments(reportId){
  $.ajax({
    url: '/reports/' + reportId + '/get_comments',
    dataType: 'JSON',
    type: 'GET',
    success: function(response){
      localStorage.setItem('comments', JSON.stringify(response))
      showComments()
    }
  })
}

function showComments(){
  source = $('#comment-template').html();
  templ = Handlebars.compile(source)
  comments = JSON.parse(localStorage.getItem('comments'));
  var comment_html = templ(comments)
  $('.comments_data').html(comment_html);
}

function showNotes(){
  source = $('#note-template').html();
  templ = Handlebars.compile(source)
  notes = JSON.parse(localStorage.getItem('notes'));
  var notes_html = templ(notes)
  $('.notes_data').html(notes_html);
}

function showDashNotes(type){
  notes = JSON.parse(localStorage.getItem('notes'));
  var relevant_notes = []
  $.each(notes, function(i, v){
    if(v.subject == type){
      relevant_notes.push(notes[i])
    }
  })
  source = $('#note-template').html();
  templ = Handlebars.compile(source)
  var notes_html = templ(relevant_notes)
  $('.notes_data').html(notes_html);
  $("#report-notes-modal").trigger("click")
}

function showDashComments(type){
  comments = JSON.parse(localStorage.getItem('comments'));
  var relevant_comments = []
  $.each(comments, function(i, v){
    if(v.subject == type){
      relevant_comments.push(comments[i])
    }
  })
  source = $('#comment-template').html();
  templ = Handlebars.compile(source)
  var comment_html = templ(relevant_comments)
  $('.comments_data').html(comment_html);
  $("#report-comments-modal").trigger("click")
}


$(document).on('page:load ready', function(){

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
  // end of values breakdown

  var route = document.location.href
  var endOfRoute = route.slice(-4);
  console.log(endOfRoute);
        
  if (route.indexOf('show_dashboard') > -1) {
       // cache graph data
       var dashData = ifrsDashShow.loadData();
       // LOAD MARGIN STATISTICS
       ifrsDashShow.loadStats();
       // DRAW GOOGLE CHARTS
       graphHelper.drawFSCharts(dashData);
       //graphHelper.loadStats(stats)
       $('.fs-scroll').on('click', function(e) {
         e.preventDefault();
         anchor = $(this).data('anchor')
         var top = $('#' + anchor).offset().top - 50
         $('html, body').animate({ scrollTop: top }, 1500)
      });

  } else {
      data = reportHelper.loadShowPageData()
      reportHelper.drawCharts(data);
  }

})
// END OF REPORTS DOCUMENT ON LOAD JS
