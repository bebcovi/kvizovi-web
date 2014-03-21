jQuery ->

  $(".additional-info").each ->
    $this = $(@)
    $icon = $($.icon("question-circle-full"))
    text  = $this.text()

    $this.replaceWith($icon)

    $icon
      .addClass("additional-info help")
      .attr("title", text)
      .tooltip
        placement: "left"
        animation: true
