do ($ = jQuery) ->

  $(document).on "click", ".modal_close", (event) ->
    event.preventDefault()
    $(@).closest(".modal").modal("hide").remove()

  $(document).on "click", ".delete_item", (event) ->
    event.preventDefault()
    $.modalAjax
      url: @href
