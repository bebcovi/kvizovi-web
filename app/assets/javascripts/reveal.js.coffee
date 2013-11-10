jQuery ->

 $(".reveal-content").each ->
   new ContentReveal(@).enable()

class @ContentReveal

  constructor: (container) ->
    @container = $(container)

  enable: ->
    @toggleButton()
      .appendTo(@container.prev())
      .on "click", @toggleVisibility
      .tooltip(placement: "bottom", container: "body")

  toggleVisibility: (event) =>
    event.preventDefault()
    $(event.target).toggleClass("is-hidden")
    @container.toggleClass("is-hidden")

  toggleButton: ->
    $("<a>", href: "#", class: "reveal-toggle is-hidden", title: @container.attr("title"))
