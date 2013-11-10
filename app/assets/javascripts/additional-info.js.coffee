#= require ./utils/icon

jQuery ->

  $(".additional-info").each ->
    icon   = $.icon("question-circle-full")
    hint    = $(@).text()

    $(@).replaceWith $(icon)
      .addClass("additional-info help")
      .attr("title", hint)
      .tooltip(placement: "right")
