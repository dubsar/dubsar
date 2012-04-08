class Field
  constructor: (@name, @type) ->

class Fields
  fields = []
  add: (_field) ->
    fields.push(_field)
    alert(this.json())
  json: ->
    JSON.stringify(fields)

jQuery ->
  fields = new Fields
  $("#field_form_submit").click  ->
    name = $("#field_form_name").val()
    type = $("#field_form_type").val()
    f = new Field(name, type)
    fields.add(f)
  $("#new_name_form").submit ->
    $("#new_name_fields").val(fields.json)
