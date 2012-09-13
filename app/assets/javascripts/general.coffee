Lektire.general = ->

  $('.flash button').on 'click', -> $(@).parent().fadeOut(250)
  $('.controls a, table button').tooltip()
