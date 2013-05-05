do ($ = jQuery) ->

  $form = $("[data-confirm-leave]")

  if $form.length

    $(document).on "click", "a", (event) ->
      event.preventDefault()
      $this = $(@)
      href = @href

      unless $this.closest($form).length or $this.closest(".modal").length or $this.hasClass("dropdown-toggle")
        $.modalAjax
          url: $form.find(".cancel").attr("href")
          onSubmit: do (href) ->
            (event) ->
              event.preventDefault()
              clearStorage()
              location.href = href
