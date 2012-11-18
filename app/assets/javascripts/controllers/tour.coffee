$ = jQuery

App.Controllers.tour =

  index: ->

    $('.nav-tabs a').first().tab('show')

    $('#skole').find('ol').addClass("question-types")
