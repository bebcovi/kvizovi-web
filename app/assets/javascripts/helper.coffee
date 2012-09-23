$ = jQuery

App.helper =

  init: ->

    $('p:has(img)').addClass 'img'
    $('table').wrap '<div class="table">'
    $('[type=text]').attr 'autocomplete', 'off'
