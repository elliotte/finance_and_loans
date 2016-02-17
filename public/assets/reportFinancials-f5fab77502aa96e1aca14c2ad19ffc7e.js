function successDashExport(){$("#bg-screen-for-modal").addClass("open"),response=this.responseText,response.indexOf("ERROR")>-1?html='<article class="type-system-slab"><p>ERROR</p><a href="/" data-no-turbolinks=true>RECONNECT</a></article>':(link='<a href="'+response+'" target="_blank">VIEW</a>',html='<article class="type-system-slab"><p>Successful Export: '+link+"</p></article>"),$("#bg-screen-for-modal").find("section").empty().html(html)}function fetchData(){var a=$(".js-fs-line"),s=[];return $.each(a,function(a,t){tag=$(t).data("tag"),lineDescription=$(t).data("reporting-line"),cy_amt=$(t).data("cy"),py_amt=$(t).data("py"),row=[lineDescription,cy_amt,py_amt,tag],s.push(row)}),s}function exportDashOffice(){var a=fetchData();$.ajax({url:"/reports/"+$("#report-id").val()+"/export_dash_o365",type:"POST",data:{csv:JSON.stringify(a)}})}var ready;ready=function(){var a=ifrsDashShow.loadData();ifrsDashShow.loadStats(),format=$("#dash-report-format").data("value"),subtitleText="Using "+format+" classifications";try{var s=a.cy,t=a.py;graphHelper.drawPNLDashCharts(s,t,document.getElementById("income-statement-graph"))}catch(e){console.log(e)}try{var s=a.cy.assets,t=a.py.assets;graphHelper.drawBSAssetChart(s,t,"Company assets",document.getElementById("assets-graph"))}catch(e){console.log(e)}try{var s=a.cy.liabs,t=a.py.liabs;graphHelper.drawBSLiabChart(s,t,"Company liabilities",document.getElementById("liabs-graph"))}catch(e){console.log(e)}uiSharedHelper.setAccordianHandlers(),$(".values_breakdown").on("click",function(){range=$(this).attr("data-period"),lineTag=$(this).attr("data-ifrstag"),summary=$(this).data("summary-line"),summary?(summaryTag=$(this).data("summary-tag"),_data={ifrstag:lineTag,period:range,summary:summaryTag}):_data={ifrstag:lineTag,period:range},$.ajax({url:"/reports/"+$("#report-id").val()+"/get_breakdown_values",dataType:"SCRIPT",type:"GET",data:_data})})},$(document).ready(ready),$(document).on("page:load",ready);var ifrsDashShow=function(){return{cacheData:function(){var a={cy:{gp_rev:[],gp_cos:[],op_rev:[],op_cos:[],tax:[],assets:[],liabs:[]},py:{gp_rev:[],gp_cos:[],op_rev:[],op_cos:[],tax:[],assets:[],liabs:[]}},s=$(".js-fs-line");return $.each(s,function(s,t){switch(tag=$(t).data("tag"),lineDescription=$(t).data("reporting-line"),cy_amt=$(t).data("cy"),py_amt=$(t).data("py"),cy_info=[lineDescription,cy_amt],py_info=[lineDescription,py_amt],tag){case"gp-rev":a.cy.gp_rev.push(cy_info),a.py.gp_rev.push(py_info);break;case"gp-cos":a.cy.gp_cos.push(cy_info),a.py.gp_cos.push(py_info);break;case"op-rev":a.cy.op_rev.push(cy_info),a.py.op_rev.push(py_info);break;case"op-cos":a.cy.op_cos.push(cy_info),a.py.op_cos.push(py_info);break;case"pbt-cos":a.cy.tax.push(cy_info),a.py.tax.push(py_info);break;case"tax":a.cy.tax.push(cy_info),a.py.tax.push(py_info);break;case"fa_tang":a.cy.assets.push(cy_info),a.py.assets.push(py_info);break;case"fa_intang":a.cy.assets.push(cy_info),a.py.assets.push(py_info);break;case"curr_assets":a.cy.assets.push(cy_info),a.py.assets.push(py_info);break;case"ca":a.cy.assets.push(cy_info),a.py.assets.push(py_info);break;case"nca":a.cy.assets.push(cy_info),a.py.assets.push(py_info);break;case"assets":a.cy.assets.push(cy_info),a.py.assets.push(py_info);break;case"cred_current":a.cy.liabs.push(cy_info),a.py.liabs.push(py_info);break;case"cred_greater":a.cy.liabs.push(cy_info),a.py.liabs.push(py_info);break;case"capital":a.cy.liabs.push(cy_info),a.py.liabs.push(py_info);break;case"ncl":a.cy.liabs.push(cy_info),a.py.liabs.push(py_info);break;case"cl":a.cy.liabs.push(cy_info),a.py.liabs.push(py_info);break;case"liabs":a.cy.liabs.push(cy_info),a.py.liabs.push(py_info)}}),a},loadStats:function(){gpData=[$("#js-gp-margin-data"),$("#js-op-margin-data"),$("#js-margin-data")],cy_statsViewList=$("#cy-p-n-l-stats"),py_statsViewList=$("#py-p-n-l-stats"),$.each(gpData,function(a,s){switch(statText=$(s).attr("id"),displayText="",statText){case"js-gp-margin-data":displayText="GP Margin";break;case"js-op-margin-data":displayText="OP Margin";break;case"js-margin-data":displayText="Profit Margin"}cy_html="<li>"+$(s).data("cy")+"<span>"+displayText+"</span></li>",py_html="<li>"+$(s).data("py")+"<span>"+displayText+"</span></li>",$(cy_statsViewList).append(cy_html),$(py_statsViewList).append(py_html)})},loadData:function(){var a=this.cacheData();return a},exportDashGoogle:function(){var a=fetchData(),s=$("meta[name='csrf-token']").attr("content"),t=new XMLHttpRequest;t.onload=successDashExport,t.open("post","/reports/"+$("#report-id").val()+"/export_dash",!0),t.setRequestHeader("Content-Type","application/json"),t.setRequestHeader("X-CSRF-Token",s),t.send(JSON.stringify(a))}}}();