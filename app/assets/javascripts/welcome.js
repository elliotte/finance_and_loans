// ACTION BAR DROPDOWN ACTIVate
$(document).ready(function(){
  $(".dropdown-button").click(function() {
    $(".dropdown-menu").toggleClass("show-menu");
    $(".dropdown-menu > li").click(function(){
      $(".dropdown-menu").removeClass("show-menu");
    });
    $(".dropdown-menu.dropdown-select > li").click(function() {
      $(".dropdown-button").html($(this).html());
    });
  });
});

// SLIDER MENU ACTIVATE JS
$('.sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close').on('click touchstart',function (e) {
	$('.sliding-panel-content,.sliding-panel-fade-screen').toggleClass('is-visible');
	e.preventDefault();
});
