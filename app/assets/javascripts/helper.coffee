define ['jquery'], ($) ->

  ->

    $('table').wrap '<div class="table">'
    $('[type=text]').attr 'autocomplete', 'off'
