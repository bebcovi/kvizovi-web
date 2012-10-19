$ = jQuery

App.general = ->

  # closing flash messages

  $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')

  # bootstrap tooltips

  $('.controls a, button').tooltip()
  $('a.icon-info').tooltip
    placement: 'left'

  # info

  $('a.icon-info').fancybox
    wrapCSS: 'alert long'

  # delete confirmation

  $('.controls').find('a:last-child').fancybox
    wrapCSS:  'confirm'
    width:    250
    type:     'ajax'
