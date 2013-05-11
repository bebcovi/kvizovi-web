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
          onOpen: do ($this) ->
            ($modal) ->
              $btnSubmit    = $modal.find($.rails.linkClickSelector)
              $newBtnSubmit = $("<button>", type: "button", text: $btnSubmit.text(), class: "btn btn-primary")
              $btnSubmit.replaceWith($newBtnSubmit)
              $newBtnSubmit.on "click", do ($this) ->
                -> location.href = $this[0].href
