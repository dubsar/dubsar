#= require jqcloud
$ ->
  $.ajax '/cloud'
    type: 'GET'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      $("#cloud").jQCloud(data) if $("#cloud")
  $("#search-dubsar").focus() if $("#search-dubsar")

