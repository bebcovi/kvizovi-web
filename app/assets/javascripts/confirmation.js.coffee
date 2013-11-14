#= require ./templates/confirmation

$.rails.allowAction = ($link) ->
  if $link.attr("data-confirm")
    new Confirmation($link.attr("data-confirm")).show(
      onConfirm: => $.rails.confirmed($link)
    )
    false
  else
    true

$.rails.confirmed = ($link) ->
  $link.removeAttr("data-confirm")
  $link.trigger("click.rails")

class @Confirmation

  constructor: (@message) ->

  show: (@options) ->
    $(JST["templates/confirmation"](message: @message))
      .modal()
      .on "click", ".confirm", => @options.onConfirm()
