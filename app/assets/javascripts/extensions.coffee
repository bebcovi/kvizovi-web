# methods

jQuery.fn.prependIcon = (name) ->
  @.each -> $(@).prepend "<i class=\"icon-#{name}\">"

jQuery.fn.appendIcon = (name) ->
  @.each -> $(@).append "<i class=\"icon-#{name}\">"

# properties

$.removeButton = $ '<button>',
  type: 'button'
  tabindex: -1
.addClass('remove')
.prependIcon('cancel')

$.addButton = $ '<button>',
  type: 'button'
.addClass('add')
.text(' Dodaj')
.prependIcon('plus')

window.Lektire =
  Controllers: {}
  Questions: {}
