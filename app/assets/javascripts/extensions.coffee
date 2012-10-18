$ = jQuery

# methods

$.fn.prependIcon = (name) ->
  @.each -> $(@).prepend "<i class=\"icon-#{name}\"> "

$.fn.appendIcon = (name) ->
  @.each -> $(@).append " <i class=\"icon-#{name}\">"

# properties

$.removeButton = $ '<button>',
  type: 'button'
  tabindex: -1
.addClass('remove')
.prependIcon('cancel')

$.addButton = $ '<a>',
  href: '#'
.addClass('add')
.text(' Dodaj')
.prependIcon('plus')

$.timer = $('<div>')
.addClass('timer')
.prependIcon('stopwatch')
.append $('<span>', {class: 'time'})

$.loader = $('<div>')
.addClass('loader')
.prependIcon('loading')

$.extend $.fancybox.defaults,
  height:       'auto'
  autoSize:     false
  topRatio:     0.3
  padding:      30
  openEffect:   'none'
  closeEffect:  'none'

  beforeShow: ->
    unless @type is 'ajax'
      if /alert/.test @wrapCSS
        @inner.append $.generateButtons
          close: 'U redu'
      if /confirm/.test @wrapCSS
        @inner.append $.generateButtons
          close: 'Nisam'
          submit: 'Jesam'

    @inner.find('.buttons').find('a').on 'click', (event) ->
      event.preventDefault()
      $.fancybox.close(true)

# functions

$.flashMsg = (msg, name) ->
  $flash = $('<div>').addClass("flash #{name}")

  $button = $.removeButton
    .clone()
    .appendTo($flash)

  $msg = $('<p>').append(msg)

  $flash
    .append($msg)
    .prependTo('#main')

  $button.on 'click', -> $flash.fadeOut('fast')

$.getContent = (title, body) ->
  $title    = $('<h1>').text(title)
  $body     = $('<p>').text(body)

  $content  = $()

  $content.after($title)  if title
  $content.after($body)   if body

  $content

$.generateButtons = (labels) ->
  $result = $('<div>').addClass('buttons')

  if labels['close']
    $close = $('<a>', href: '#').text(labels['close'])
    $result.append($close)

  if labels['submit']
    $submit = $('<button>', type: 'button').text(labels['submit'])
    $result.append($submit)

  $result

# globals

window.App =
  Controllers: {}
  Questions: {}
