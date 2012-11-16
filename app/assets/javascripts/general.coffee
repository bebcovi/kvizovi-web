$ = jQuery

App.general = ->

  # tooltips & popovers

  $('a[title], button[title]').tooltip
    animation: false
    placement: 'top'
    container: 'body'

  $('input[type="text"]').popover
    html: true
    trigger: 'focus'

  # modals

  $(document).on 'click', '.modal_close', (event) ->
    event.preventDefault()
    $(@).closest('.modal').modal('hide').remove()

  $(document).on 'click', '.delete_item', (event) ->
    event.preventDefault()
    $.modalAjax
      url: @href

  $('.alert-info').find('.close').removeClass('btn')

  # # notification

  # $('.flash.notification').find('form').on 'submit', (event) ->
  #   event.preventDefault()

  #   $form = $(@)

  #   $.ajax
  #     type: $form.attr('method')
  #     url: $form.attr('action')
  #     data: $form.serialize()

  #   $form.closest('.flash')
  #     .fadeOut 'fast', -> $(@).remove()
