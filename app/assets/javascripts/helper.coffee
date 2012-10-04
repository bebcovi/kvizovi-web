$ = jQuery

App.helper =

  init: ->

    $('table').wrap '<div class="table">'
    $('[type=text]').attr 'autocomplete', 'off'
