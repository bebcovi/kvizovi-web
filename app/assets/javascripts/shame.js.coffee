do ($ = jQuery) ->

  # turn off auto-complete in text inputs

  $('[type="text"], [type="url"]').attr 'autocomplete', 'off'

  # remove the .btn class

  $('.alert-info').find('.close').removeClass('btn')
