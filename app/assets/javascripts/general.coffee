$ = jQuery

App.general = ->

  # hints

  $(".help-block").each ->
    $this   = $(@)
    hint    = $this.text()
    icon    = $.icon("question-circle-full")
    $icon   = $(icon)

    $this.replaceWith($icon)

    $icon
      .addClass("additional-info help")
      .attr("title", hint)

  # tooltips & popovers

  $("a, input[type=\"submit\"], button").filter("[title]").not("[data-content]").tooltip
    animation: false
    placement: "top"
    container: "body"

  $(".additional-info").tooltip
    animation: false
    placement: "right"
    container: "body"

  $("input[type=\"text\"][data-content]").popover
    html: true
    trigger: "focus"

  $("button[data-content]").popover
    animation: false
    html: true
    trigger: "hover"

  # dropdowns

  $(".dropdown-hover")
    .on "mouseenter", ->
      unless $(@).hasClass("open")
        $(@).find(".dropdown-toggle")
          .dropdown("toggle")

    .on "mouseleave", ->
      if $(@).hasClass("open")
        $(@).find(".dropdown-toggle")
          .dropdown("toggle")
          .blur()

  # modals

  $(document).on "click", ".modal_close", (event) ->
    event.preventDefault()
    $(@).closest(".modal").modal("hide").remove()

  $(document).on "click", ".delete_item", (event) ->
    event.preventDefault()
    $.modalAjax
      url: @href
