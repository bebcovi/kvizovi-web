$ = jQuery

App.Questions.choice =

  new: ($form) ->

    $options      = $('li', $form)
    $firstOption  = $options.first()
    $otherOptions = $firstOption.siblings()
    $template     = $firstOption.clone()

    $addButton    = $.addButton.clone()

    updateAttrs   = ($el, i) ->

      $input = $el.find 'input'

      i += 2

      id = $input.attr('id')
      placeholder = $input.attr('placeholder')

      $input.attr 'id',           id.replace(/\d+/, i)
      $input.attr 'placeholder',  placeholder.replace(/\d+/, i)

    addOption = ($el) ->
      $otherOptions = $otherOptions.add $el.insertBefore($addButton)

    removeOption = ($el) ->
      $otherOptions = $otherOptions.not $el.remove()

    filled = ($el) ->
      result = true
      $el.find('input').each -> result = result and !!$(@).val()
      result

    $otherOptions.add($template).append $.removeButton.clone()

    $template
      .find('input').val('').end()
      .find('div').removeClass('field_with_hint field_with_errors').end()
      .find('.hint, .error').remove()

    $addButton
      .insertAfter($otherOptions.last())
      .on 'click', (event) ->
        $new = $template.clone()
        event.preventDefault()
        updateAttrs $new, $otherOptions.length
        addOption $new

    $form.on 'click', '.remove', ->
      $el = $(@).closest('li')
      removeOption $el
      $otherOptions.each (i) -> updateAttrs $(@), i

  edit: ($form) ->

    @new $form
