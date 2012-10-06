$ = jQuery

App.Questions.photo = module = {}

module.new = ($form) ->

  # Previewing images using the FileSystem API:
  # http://stackoverflow.com/a/4459419/1247274

  $file         = $form.find '[type=file]'
  $img          = $form.find '.preview'
  img           = $img[0]
  $placeholder  = $form.find '.placeholder'

  $img.show() if $img.attr 'src'

  $placeholder.on 'click', -> $file.click()

  $file.on 'change', (event) ->

    reader    = new FileReader
    file      = event.target.files[0]

    reader.onload = (e) ->

      img.src     = e.target.result
      img.onload  = ->
        $img.show()
        $('.placeholder').hide()

    if /image/.test file.type
      reader.readAsDataURL file
    else
      alert "Datoteka #{file.name} nije slika."

module.edit = ($form) ->

  module.new($form)
