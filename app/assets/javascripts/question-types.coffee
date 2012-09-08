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

    # photo

    # Drawing images from File API to canvas:
    # http://stackoverflow.com/a/6776055/1247274

    # Scaling drawn images proportionally:
    # http://stackoverflow.com/a/10842366/1247274

    $form = $('form.photo')

    $file = $form.find '[type=file]'

    $file.on 'change', (e) ->
      $canvas   = $('canvas')
      canvas    = $canvas[0]

      width     = $canvas.attr('width') - 0
      height    = $canvas.attr('height') - 0

      ctx       = canvas.getContext '2d'
      reader    = new FileReader

      ctx.clearRect 0, 0, canvas.width, canvas.height

      reader.onload = (event) ->
        img = new Image
        img.src = event.target.result
        img.onload = ->

          newWidth = height * img.width / img.height
          canvas.width = newWidth

          ctx.drawImage img, 0, 0, newWidth, height
          $canvas.addClass 'filled'

      reader.readAsDataURL e.target.files[0]
