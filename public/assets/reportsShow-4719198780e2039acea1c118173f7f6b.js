$(document).on("page:load ready",function(){var a=document.location.href,o=a.slice(-4);console.log(o),a.indexOf("show_dashboard")>-1||(data=reportHelper.loadShowPageData(),graphHelper.drawReportShowCharts(data))});