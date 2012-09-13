Lektire.Questions.photo = ($form, formClass) ->

  if formClass.search(/edit|new/) isnt -1

    # Drawing images from File API to canvas:
    # http://stackoverflow.com/a/6776055/1247274

    # Scaling drawn images proportionally:
    # http://stackoverflow.com/a/10842366/1247274

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
