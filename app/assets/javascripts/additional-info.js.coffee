#= require ./utils/icon

jQuery ->

  $(".additional-info").each ->
    icon = $.icon("question-circle-full")
    info = $(@).text()

    $(@).replaceWith $(icon)
      .addClass("additional-info help")
      .attr("title", info)
      .tooltip(placement: "right")
