do ($ = jQuery) ->

  $(".additional-info").each ->
    $this   = $(@)
    hint    = $this.text()
    icon    = $.icon("question-circle-full")
    $icon   = $(icon)

    $this.replaceWith($icon)

    $icon
      .addClass("additional-info help")
      .attr("title", hint)
