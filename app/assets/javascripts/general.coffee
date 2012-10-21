$ = jQuery

App.general = ->

  # closing flash messages

  $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')

  # bootstrap tooltips

  $('.controls a, button').tooltip()
  $('a.tour').tooltip
    placement: 'left'

  # delete confirmation

  $('.controls').find('a:last-child').fancybox
    wrapCSS:  'confirm'
    width:    250
    type:     'ajax'
