Lektire.Initializers.questions = ->

  switch $('body').attr('class').split(' ')[1]

    when 'edit', 'new', 'create'

      # Drawing images from File API to canvas:
      # http://stackoverflow.com/a/6776055/1247274
      #
      # Scaling drawn images proportionally:
      # http://stackoverflow.com/a/10842366/1247274

      $('[type=file]').on 'change', (e) ->
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
