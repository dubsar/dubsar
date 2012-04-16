class Field
  constructor: (@name, @type) ->

class Fields
  fields = []
  add: (_field) ->
    fields.push(_field)
  json: ->
    JSON.stringify(fields)

jQuery ->
  fields = new Fields
  $("#field_form_submit").click  ->
    name = $("#field_form_name").val()
    type = $("#field_form_type").val()
    f = new Field(name, type)
    alert( "name : " + name + ", type : " + type)
    fields.add(f)
  $("#new_name_form").submit ->
    $("#new_name_fields").val(fields.json)

