$ = jQuery

App.questions.photo =

  init: ($form, formClass) ->

    if ~formClass.search /edit|new/

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

      drawImage = (src) ->
        img = new Image
        img.src = src

        img.onload = ->
          ctx.clearRect 0, 0, canvas.width, canvas.height

          if img.height > height
            newWidth = height * img.width / img.height
            canvas.width = newWidth
            canvas.height = 250
            ctx.drawImage img, 0, 0, newWidth, height
          else
            canvas.width = img.width
            canvas.height = img.height
            ctx.drawImage img, 0, 0, img.width, img.height

          $canvas.addClass 'filled'

      if src
        drawImage src
        $('.pladeholder').hide()

      $file.on 'change', (event) ->

        width     = $canvas.attr('width') - 0
        reader    = new FileReader

        reader.onload = (e) -> drawImage(e.target.result)
        reader.readAsDataURL event.target.files[0]
