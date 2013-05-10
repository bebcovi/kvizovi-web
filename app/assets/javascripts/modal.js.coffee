do ($ = jQuery) ->

  $(document).on "click", ".confirm-delete", (event) ->
    event.preventDefault()
    $.modalAjax
      url: @href
