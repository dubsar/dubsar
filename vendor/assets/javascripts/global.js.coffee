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
