jQuery ->

  $(".reveal-content").each ->
    new ContentReveal(@).enable()

class @ContentReveal

  constructor: (content) ->
    @content = $(content)

  enable: ->
    return if @content.isEmpty()

    @content.hide()

    @showButton()
      .appendTo(@content.prev())
      .on("click", @showContent)
      .tooltip(placement: "right", container: "body")

  showContent: (event) =>
    event.preventDefault()
    @content.show()
    $(event.target).hide()

  showButton: ->
    $("<a>", href: "#", class: "reveal-toggle", title: @content.attr("data-reveal"))
