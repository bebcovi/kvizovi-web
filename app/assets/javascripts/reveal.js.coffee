jQuery ->

  new ContentReveal(".reveal-content").enable()

class @ContentReveal

  constructor: (container) ->
    @container = $(container)

  enable: ->
    return if @container.isEmpty()

    @container.hide()

    @showButton()
      .appendTo(@container.prev())
      .on "click", @showContent
      .tooltip(placement: "bottom", container: "body")

  showContent: (event) =>
    event.preventDefault()
    @container.show()
    $(event.target).hide()

  showButton: ->
    $("<a>", href: "#", class: "reveal-toggle is-hidden", title: @container.attr("title"))
