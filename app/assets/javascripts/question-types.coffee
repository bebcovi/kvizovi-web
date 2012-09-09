Lektire.Initializers.questionTypes = ->

  route = $('body').attr('class')

  # show

  if route.search(/games|questions show/) != -1

    # association

    conversion = (el) ->
      result = el.clone()
      result.find('input').each -> $(@).replaceWith($(@).val())
      el.after(result)
      el.hide()
      result

    $form             = $('form.association')

    $static           = {}
    $interactive      = {}

    $static.old       = $form.find('.static')
    $static.new       = conversion($static.old)

    $interactive.old  = $form.find('.interactive')
    $interactive.new  = conversion($interactive.old)

    swap = ($one, $two) ->
      $oneParent = $one.parent()
      $twoParent = $two.parent()

      $one.appendTo $twoParent
      $two.appendTo $oneParent

    $interactive.new.find('div')
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

  # edit/new

  else if route.search(/questions (edit|new|create)/) != -1

    # choice

    $form = $('form.choice')

    if $form.length > 0

      # variables

      $options      = $('.field_with_hint').nextAll '.string'
      $template     = []

      $removeButton = $('<button>') .attr('type', 'button')
                                    .addClass('remove')
                                    .prependIcon('remove')

      $addButton    = $('<button>') .attr('type', 'button')
                                    .addClass('add')
                                    .text('Dodaj opciju')
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

      $options.each -> $(@).find('input').after $removeButton.clone()

      $template = $options.first().clone()

      $template.find('input').val ''
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

    # photo

    # Drawing images from File API to canvas:
    # http://stackoverflow.com/a/6776055/1247274

    # Scaling drawn images proportionally:
    # http://stackoverflow.com/a/10842366/1247274

    $form = $('form.photo')

    if $form.length > 0

      $file    = $form.find '[type=file]'

      $canvas  = $form.find 'canvas'
      canvas   = $canvas[0]
      src      = $canvas.attr 'data-src'
      height   = $canvas.attr('height') - 0
      ctx      = canvas.getContext '2d'

      drawImage = (event) ->
        img = new Image
        img.src = event.target.result

        img.onload = ->
          ctx.clearRect 0, 0, canvas.width, canvas.height

          newWidth = height * img.width / img.height
          canvas.width = newWidth

          ctx.drawImage img, 0, 0, newWidth, height

          $canvas.addClass 'filled'

      if src
        drawImage({target: {result: src}})
        $('.pladeholder').hide()

      $file.on 'change', (event) ->

        width     = $canvas.attr('width') - 0
        reader    = new FileReader

        reader.onload = drawImage
        reader.readAsDataURL event.target.files[0]
