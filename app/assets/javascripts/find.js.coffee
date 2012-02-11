jQuery ->
  $(".item").click ->
    $("#item-id").val($(this).data("d-item-id"))
    $("#item-class").val($(this).data("d-item-class"))
    $("#view").submit()

