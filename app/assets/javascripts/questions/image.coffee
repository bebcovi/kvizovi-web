$ = jQuery

App.Questions.image = do ->

  new: ($form) ->

    # Previewing images using the FileSystem API:
    # http://stackoverflow.com/a/4459419/1247274

    $file = $form.find '[type=file]'
    $img  = $form.find '.preview'
    img   = $img[0]

    $img.hide()

    $file.on 'change', (event) ->

      reader = new FileReader
      file   = event.target.files[0]

      reader.onload = (e) ->

        img.src     = e.target.result
        img.onload  = -> $img.show()

      if /image/.test file.type
        reader.readAsDataURL file
      else
        alert "Datoteka #{file.name} nije slika."

  edit: ($form) ->

    @new $form
    $img.show()
