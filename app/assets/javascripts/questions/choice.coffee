Lektire.Initializers.questions.push ->

  $form = $('form.choice')

  if $form.length > 0

    if $form.attr('class').search(/edit|new/) != -1

      # variables

      $options      = $form.find('.field_with_hint').nextAll '.string'
      $template     = []

      $removeButton = $('<button>') .attr('type', 'button')
                                    .attr('tabindex', '-1')
                                    .addClass('remove')
                                    .prependIcon('cancel')

      $addButton    = $('<button>') .attr('type', 'button')
                                    .addClass('add')
                                    .text(' Dodaj')
                                    .prependIcon('plus')

      updateAttrs   = ($el, i) ->

        $input = $el.find 'input'

        i += 2

        id = $input.attr('id')
        placeholder = $input.attr('placeholder')

        $input.attr 'id',           id.replace(/\d+/, i)
        $input.attr 'placeholder',  placeholder.replace(/\d+/, i)

      addOption     = ($el) -> $options = $options.add $el.insertBefore($addButton)
      removeOption  = ($el) -> $options = $options.not $el.remove()

      # action

      $options.find('input').after $removeButton.clone()

      $template = $options.first().clone()

      $template.find('input').attr 'value', ''
      $template.removeClass 'field_with_hint field_with_errors'
      $template.find('.hint, .error').remove()

      $addButton
        .insertAfter($options.last())
        .on 'click', ->
          $new = $template.clone()
          updateAttrs $new, $options.length
          addOption $new

      $form.on 'click', '.remove', ->
        $el = $(@).parent()
        removeOption $el
        $options.each (i) -> updateAttrs $(@), i
