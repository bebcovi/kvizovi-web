define ['jquery', 'bootstrap'], ($) ->

  ->

    $('.flash button').on 'click', -> $(@).parent().fadeOut('fast')
    $('.controls a, button').tooltip()
