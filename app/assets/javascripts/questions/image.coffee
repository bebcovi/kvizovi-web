$ = jQuery

App.Questions.image = do ->

  new: ($form) ->

    # Previewing images using the FileSystem API:
    # http://stackoverflow.com/a/4459419/1247274

    $file       = $('div.file', $form)
    $fileInput  = $('input', $file)
    $url        = $('div.url', $form)
    $urlInput   = $('input', $url)
    $toggleType = $('<a>', {href: '#'}).addClass('toggle-type')
    $img        = $('.preview', $form)
    img         = $img[0]

    loadImg = (src) ->
      img.src = src
      img.onload  = -> $img.show()
      img.onerror = -> $img.hide()

    $url.hide()
    $img.hide()

    $toggleType
      .on 'click', (event) ->
        event.preventDefault()
        $file.toggle()
        $fileInput.val('')
        $url.toggle()
        $urlInput.val('')
        $img.hide()

      .clone(true)
        .attr('title', 'Slika na internetu')
        .prependIcon('link')
        .prependTo($file)
        .tooltip()
        .end()

      .clone(true)
        .attr('title', 'Slika na računalu')
        .prependIcon('drive')
        .tooltip()
        .prependTo($url)

    $fileInput.on 'change', (event) ->
      reader = new FileReader
      file   = event.target.files[0]

      reader.onload = (e) ->
        loadImg e.target.result

      if /image/.test file.type
        reader.readAsDataURL file
      else
        alert "Datoteka #{file.name} nije slika."

    $url
      .on 'change', ->
        loadImg $urlInput.val()
      .on 'paste', ->
        setTimeout ->
          loadImg $urlInput.val()
        , 100

  edit: ($form) ->

    @new $form
    $img.show()
