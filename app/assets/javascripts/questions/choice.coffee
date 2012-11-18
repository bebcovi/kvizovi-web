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

    $firstOption.find('input')
      .tooltip
        placement: 'right'
        trigger: 'focus'

    $otherOptions.add($template)
      .append $.removeButton
        .clone()
        .addClass('close')
        .attr('tabindex', -1)

    $template
      .find('input').val('').end()
      .find('div').removeClass('success').end()
      .find('.help-block, .error-block').remove()

    if $otherOptions.length
      $addButton.insertAfter($otherOptions.last())
    else
      $addButton.insertAfter($firstOption)

    $addButton
      .on 'click', (event) ->
        $new = $template.clone()
        event.preventDefault()
        updateAttrs $new, $otherOptions.length
        addOption $new

    $form.on 'click', '.close', ->
      $el = $(@).closest('li')
      removeOption $el
      $otherOptions.each (i) -> updateAttrs $(@), i

  edit: ($form) ->

    @new $form
