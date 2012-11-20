$ = jQuery

App.Questions.image =

  new: ($form) ->

    # Previewing images using the FileSystem API:
    # http://stackoverflow.com/a/4459419/1247274

    $file       = $('div.file', $form)
    $fileInput  = $('input', $file)
    $url        = $('div.url', $form)
    $urlInput   = $('input', $url)

    $toggleType = $('<a>', {href: '#'}).addClass('btn toggle_type')

    $img        = $('.preview', $form)
    img         = $img[0]
    existingSrc = img.src

    isFileEmpty = not $fileInput.val() # it's always empty, lol
    isUrlEmpty  = not $urlInput.val()

    isNew       = not existingSrc
    isEdit      = $form.hasClass('edit')
    isCreate    = not (isNew or isEdit)

    loadImg = (src) ->
      img.src = src
      img.onload = -> $img.show()

    if isNew or isUrlEmpty
      $file.show()
    else
      $url.show()

    $toggleType
      .on 'click', (event) ->
        event.preventDefault()
        $file.toggle()
        $url.toggle()

      .clone(true)
        .attr('title', 'Na internetu')
        .html($.icon('link'))
        .prependTo($file)
        .tooltip()
        .end()

      .clone(true)
        .attr('title', 'Na računalu')
        .html($.icon('drive'))
        .tooltip()
        .prependTo($url)

    $fileInput.on 'change', (event) ->
      if $(@).val()
        reader = new FileReader
        file   = event.target.files[0]

        $urlInput.val('')

        reader.onload = (e) ->
          loadImg e.target.result

        if /image/.test file.type
          reader.readAsDataURL file
        else
          alert "Datoteka #{file.name} nije slika."
      else
        if not isNew
          loadImg existingSrc
        else
          $img.hide()

    $urlInput
      .on 'change', ->
        if $urlInput.val()
          $fileInput.val('')
          loadImg $urlInput.val()
        else
          if not isNew
            loadImg existingSrc
          else
            $img.hide()

      .on 'paste', ->
        setTimeout ->
          loadImg $urlInput.val()
        , 100

  edit: ($form) ->

    @new $form
