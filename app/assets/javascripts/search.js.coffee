#= require jqcloud
$ ->
  if $("#cloud").exists()
    $.ajax '/cloud'
      type: 'GET'
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        $("#cloud").jQCloud(data) 
  $("#search-dubsar").focus() if $("#search-dubsar").exists()

