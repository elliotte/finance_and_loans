var ready;ready=function(){var a=ifrsDashShow.loadData();ifrsDashShow.loadStats(),format=$("#dash-report-format").data("value"),subtitleText="Using "+format+" classifications";try{var t=a.cy,e=a.py;graphHelper.drawPNLDashCharts(t,e,document.getElementById("income-statement-graph"))}catch(r){console.log(r)}try{var t=a.cy.assets,e=a.py.assets;graphHelper.drawBSAssetChart(t,e,"Company assets",document.getElementById("assets-graph"))}catch(r){console.log(r)}try{var t=a.cy.liabs,e=a.py.liabs;graphHelper.drawBSLiabChart(t,e,"Company liabilities",document.getElementById("liabs-graph"))}catch(r){console.log(r)}},$(document).ready(ready),$(document).on("page:load",ready),$(document).on("page:load ready",function(){$(".fs-scroll").on("click",function(a){a.preventDefault(),anchor=$(this).data("anchor");var t=$("#"+anchor).offset().top-50;$("html, body").animate({scrollTop:t},1500)}),$(".values_breakdown").on("click",function(){range=$(this).attr("data-period"),lineTag=$(this).attr("data-ifrstag"),summary=$(this).data("summary-line"),summary?(summaryTag=$(this).data("summary-tag"),_data={ifrstag:lineTag,period:range,summary:summaryTag}):_data={ifrstag:lineTag,period:range},$.ajax({url:"/reports/"+$("#report-id").val()+"/get_breakdown_values",dataType:"SCRIPT",type:"GET",data:_data})})});