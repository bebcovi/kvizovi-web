do ($ = jQuery) ->

  $.modalAjax = (options = {}) ->
    $("body").spin($.spinnerOptions)

    $.ajax
      type: options["type"] or "GET"
      url: options["url"]
      data: options["data"] or ""
      dataType: "html"
      headers: {"X-noLayout": true}

      success: (data) ->
        $data   = $(data).children()
        $modal  = $data.parent()

        $header = $data.filter(".modal-header")
        $body   = $data.filter(".modal-body")
        $footer = $data.filter(".modal-footer")

        # loader

        $("body").spin(false)

        # modifications

        $footer.find(".cancel")
          .removeClass("cancel")
          .attr("data-dismiss", "modal")

        # init

        $modal.modal()

        # required

        if options["required"]
          $closeButton.remove()
          $modal.on "hide", -> return false

        # callbacks

        $modal.on "hidden", ->
          $modal.remove()

        if options["onOpen"]
          options["onOpen"]($modal)

        if options["onCancel"]
          $modal.on "hidden", options["onCancel"]

        if options["onSubmit"]
          $footer.find(".btn-primary")
            .on "click", options["onSubmit"]

      error: -> location.href options["url"]

  $("[data-modal]").on "click", (event) ->
    event.preventDefault()
    $.modalAjax
      url: @href
