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
        $data = $(data).children()
        klass = $(data).filter("div").attr("class") or ""

        $closeButton = $.closeButton
          .clone()
          .addClass("close")
          .attr("data-dismiss", "modal")

        $dataHeader   = $data.filter("h1")
        $dataFooter   = $data.filter("form, .form")
        $dataBody     = $data.not($dataHeader).not($dataFooter)

        $modal        = $("<div>").addClass("modal #{klass}")

        # loader

        $("body").spin(false)

        # modifications

        $dataFooter.find(".cancel")
          .removeClass("cancel")
          .attr("data-dismiss", "modal")

        # component insertion

        $modalHeader = $("<div>")
          .addClass("modal-header")
          .append($closeButton)
          .append($dataHeader)

        $modalBody = $("<div>")
          .addClass("modal-body")
          .append($dataBody)

        $modalFooter = $("<div>")
          .addClass("modal-footer")
          .append($dataFooter)

        # modal insertion

        $modal.append($modalHeader)
        $modal.append($modalBody)   if $dataBody.length
        $modal.append($modalFooter) if $dataFooter.length

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
          $modalFooter.find(".btn-primary")
            .on "click", options["onSubmit"]

      error: -> location.href options["url"]
