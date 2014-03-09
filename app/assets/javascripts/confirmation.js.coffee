#= require ./templates/confirmation
#= require bootstrap/modal

$.rails.allowAction = ($link) ->
  if $link.attr("data-confirm")
    $(JST["templates/confirmation"] message: $link.attr("data-confirm"))
      .modal()
      .on "click", ".confirm", => $.rails.confirmed($link)
      .on "click", "[type='button']", -> $(@).closest(".modal").remove()
    false
  else
    true

$.rails.confirmed = ($link) ->
  $link.removeAttr("data-confirm")
  $link.trigger("click.rails")
