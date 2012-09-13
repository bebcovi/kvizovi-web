Lektire.Questions.association = ($form, formClass) ->

  if formClass.search(/show/) isnt -1

    $pairs    = $form.find '.pair'

    $dynamic  = $form.find '.dynamic'

    swap      = ($one, $two) ->

      $oneParent = $one.parent()
      $twoParent = $two.parent()

      $one.prependTo $twoParent
      $two.prependTo $oneParent

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


  if formClass.search(/edit|new/) isnt -1

    $pairs        = $form.find('.pair').not ':first'
    $template     = []

    $addButton    = $.addButton.clone()
    $removeButton = $.removeButton.clone()

    updateAttrs   = ($el, i) ->

      i += 2
      j = i * 2

      $el.find('.static, .dynamic').each (index) ->

        $input = $(@).find('input')

        id = $input.attr('id')
        placeholder = $input.attr('placeholder')

        $input.attr 'id',           id.replace(/\d+/, if index is 1 then j else j - 1)
        $input.attr 'placeholder',  placeholder.replace(/\d+/, i)

    addPair = ($el) ->
      $pairs = $pairs.add $el.insertBefore($addButton)

    removePair = ($el) ->
      $pairs = $pairs.not $el.fadeOut('fast', -> $(@).remove())

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
