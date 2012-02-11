#= require jquery
#= require jquery_ujs
#= require global
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


