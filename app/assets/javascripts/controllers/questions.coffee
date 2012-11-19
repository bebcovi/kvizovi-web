$ = jQuery

App.Controllers.questions =

  index: ->

    $('form.new_filter').find('input.string').tooltip
      trigger: 'focus'
