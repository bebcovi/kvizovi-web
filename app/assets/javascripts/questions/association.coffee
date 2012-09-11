Lektire.Initializers.questions.push ->

  $form = $('form.association')

  if $form.length > 0

    if $form.attr('class').search(/show/) != -1

      $pairs    = $form.find '.pair'

      $dynamic  = $form.find '.dynamic'

      swap      = ($one, $two) ->
        $oneParent = $one.parent()
        $twoParent = $two.parent()

        $one.prependTo $twoParent
        $two.prependTo $oneParent

        console.log $one.next()

        $one.next().attr 'value', $one.text()
        $two.next().attr 'value', $two.text()

      $pairs.find('input').each ->
        $el = $('<span>').text $(@).val()
        $(@).before $el
        $(@).hide()

      $dynamic.find('span')
        .draggable
          addClasses: false
          revert: 'invalid'
          revertDuration: 250
          helper: 'clone'
          zIndex: 10
          start: -> $(@).addClass 'original'
          stop:  -> $(@).removeClass 'original'

        .droppable
          addClasses: false
          hoverClass: 'hover'
          drop: (e, ui) -> swap($(@), ui.draggable)


    if $form.attr('class').search(/edit|new/) != -1

      $pairs        = $form.find('.pair').not ':first'
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

        i += 2
        j = i * 2

        $el.find('.static, .dynamic').each (index) ->

          $input = $(@).find('input')

          id = $input.attr('id')
          placeholder = $input.attr('placeholder')

          $input.attr 'id',           id.replace(/\d+/, if index == 1 then j else j - 1)
          $input.attr 'placeholder',  placeholder.replace(/\d+/, i)

      addPair       = ($el) -> $pairs = $pairs.add $el.insertBefore($addButton)
      removePair    = ($el) -> $pairs = $pairs.not $el.remove()

      # action

      $pairs.find('.dynamic').after $removeButton.clone()

      $template = $pairs.first().clone()

      $template.find('input').attr 'value', ''
      $template.removeClass 'field_with_errors'
      $template.find('.error').remove()

      $addButton
        .insertAfter($pairs.last())
        .on 'click', ->
          $new = $template.clone()
          updateAttrs $new, $pairs.length
          addPair $new

      $form.on 'click', '.remove', ->
        $el = $(@).parent()
        removePair $el
        $pairs.each (i) -> updateAttrs $(@), i
