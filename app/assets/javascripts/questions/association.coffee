$ = jQuery

App.Questions.association = do ->

  show: ($form) ->

    $pairs    = $('li', $form)

    $static   = $('.static', $pairs)
    $dynamic  = $('.dynamic', $pairs)

    widths    = []
    limit     = $form.width() * 2/3

    swap = ($one, $two) ->
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

    $static.css 'width', 'auto'

    setTimeout ->
      $static.each -> widths.push $(@).width()
      maxWidth = Math.max.apply(Math, widths) + 10
      maxWidth = limit if maxWidth > limit
      $static.each -> $(@).width(maxWidth)
    , 50

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

  new: ($form) ->

    $pairs        = $('li', $form)

    $firstPair    = $pairs.first()
    $otherPairs   = $firstPair.siblings()
    $template     = $firstPair.clone()

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
      $otherPairs = $otherPairs.add $el.insertBefore($addButton)

    removePair = ($el) ->
      $otherPairs = $otherPairs.not $el.remove()

    filled = ($el) ->
      result = true
      $el.find('input').each -> result = result and !!$(@).val()
      result

    $otherPairs.add($template).find('.dynamic').after $removeButton.clone()

    $template
      .find('input').val('').end()
      .find('div').removeClass('field_with_errors').end()
      .find('.error').remove()

    $addButton
      .insertAfter($otherPairs.last())
      .on 'click', (event) ->
        $new = $template.clone()
        event.preventDefault()
        updateAttrs $new, $otherPairs.length
        addPair $new

    $form.on 'click', '.remove', ->
      $el = $(@).closest('li')
      removePair $el
      $otherPairs.each (i) -> updateAttrs $(@), i

  edit: ($form) ->

    @new $form
