#= require jquery
#= require jquery_ujs
#= require_tree .

# global functions
jQuery ->
  $.fn.resizeContainer = () ->
    newHeight = Math.max $("#container").height(), $(window).height()
    $("#container").css("height", newHeight + "px")
    if $("#dashboard")
      containerHeight = $("#container").height()
      headerHeight = $("#header").height()
      footerHeight = $("#footer").height()
      dashboardHeight = containerHeight - headerHeight - footerHeight
      $("#dashboard").css("height", dashboardHeight + "px")
      $("#sidebar").css("height", dashboardHeight + "px")

# document ready 
jQuery ->
  $.resizeContainer()
  $('#navigation ul:last-child').hover(
    -> $(this).addClass('hover'),
    -> $(this).removeClass('hover')
  )

# adjust hight
$(window).resize ->
  resizeContainer()

