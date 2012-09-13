Lektire.general = ->

  $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')
  $('.controls a, table button').tooltip()
