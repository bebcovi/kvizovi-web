jQuery ->

  $(".additional-info").each ->
    $(@).replaceWith $($.icon("question-circle-full"))
      .addClass("additional-info help")
      .attr("title", $(@).text())
      .tooltip(placement: "right")
