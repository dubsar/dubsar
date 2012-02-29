#= require jquery
#= require jquery_ujs
#= require js/dubsar-ui
#= require_tree .

# global functions
jQuery ->
  $(this).resizeContainer()
  $(window).resize ->
    $(this).resizeContainer()
  
  $('#navigation ul:last-child').hover(
    -> $(this).addClass('hover'),
    -> $(this).removeClass('hover')
  )


