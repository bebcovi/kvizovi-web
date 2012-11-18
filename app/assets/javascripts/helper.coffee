$ = jQuery

App.helper = ->

  # turn off auto-complete in text inputs

  $('[type="text"]').attr 'autocomplete', 'off'

  # remove the .btn class

  $('.alert-info').find('.close').removeClass('btn')
