$ = jQuery

App.general = ->

  # closing flash messages

  $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')

  # bootstrap tooltips

  $('.controls a, button').tooltip()

  # info expand/collapse

  $info         = $('.info')
  $infoExpander = $ '<a>',
    href: '#'
    title: 'Pomoć'
    id: 'info-expander'
  .prependIcon('info')

  $info.addClass('collapsed')

  $('#main').prepend($infoExpander) if $info.length

  $infoExpander.tooltip placement: 'left'

  $infoExpander.on 'click', (event) ->
    event.preventDefault()
    $info.toggleClass 'collapsed'
