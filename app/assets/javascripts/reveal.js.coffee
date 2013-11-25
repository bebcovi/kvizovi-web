jQuery ->

  $(".reveal-content").each ->
    new Content(@).hide()

class Content

  constructor: (content) ->
    @content = $(content)

  hide: ->
    @content.hide()
    @createRevealButton()
      .appendTo(@content.prev())
      .tooltip(placement: "right", container: "body")

  reveal: ->
    @content.show()
    @revealButton.hide()

  createRevealButton: ->
    @revealButton = $ "<a>",
      href: "#"
      class: "reveal-toggle"
      title: @content.attr("data-reveal")

    @revealButton.on "click", (event) =>
      event.preventDefault()
      @reveal()

@Content = Content
