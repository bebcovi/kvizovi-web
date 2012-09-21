$ = jQuery

Lektire.helper = ->

  $('p:has(img)').addClass 'img'
  $('table').wrap '<div class="table">'
  $('[type=text]').attr 'autocomplete', 'off'
