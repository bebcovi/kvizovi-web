do ($ = jQuery) ->

  App.Questions.image =

    design: ($form) ->

      # Previewing images using the FileSystem API:
      # http://stackoverflow.com/a/4459419/1247274

      $fileWrapper = $form.children("div.file")
      $file        = $fileWrapper.find("div.file").hide()
      $fileInput   = $file.find("input")
      $url         = $fileWrapper.find("div.url").hide()
      $urlInput    = $url.find("input")

      $toggleType  = $("<a>", {href: "#"}).addClass("btn toggle-type")

      $img         = $(".image-preview", $form)
      img          = $img[0]
      existingSrc  = img.src

      isFileEmpty  = not $fileInput.val() # it always is, lol
      isUrlEmpty   = not $urlInput.val()

      isNew        = $form.hasClass("new")
      isEdit       = $form.hasClass("edit")
      isCreate     = $form.hasClass("create")

      loadImg = (src) ->
        img.src = src
        img.onload = -> $img.show()

      if isUrlEmpty
        $file.show()
      else
        $url.show()
        loadImg $urlInput.val()

      if isCreate and not isUrlEmpty
        loadImg $urlInput.val()

      $toggleType
        .on "click", (event) ->
          event.preventDefault()
          $file.toggle()
          $url.toggle()

        .clone(true)
          .attr("title", "Na računalu")
          .html($.icon("storage"))
          .prependTo($file)
          .end()

        .clone(true)
          .attr("title", "Na internetu")
          .html($.icon("link"))
          .prependTo($url)

      $(".toggle-type").tooltip
        animation: false
        placement: "top"

      $fileInput.on "change", (event) ->
        if $(@).val()
          reader = new FileReader
          file   = event.target.files[0]

          $urlInput.val("")

          reader.onload = (e) ->
            loadImg e.target.result

          if /image/.test file.type
            reader.readAsDataURL file
          else
            alert "Datoteka #{file.name} nije slika."
        else
          if existingSrc
            loadImg existingSrc
          else
            $img.hide()

      $urlInput
        .on "change", ->
          if $urlInput.val()
            $fileInput.val("")
            loadImg $urlInput.val()
          else
            if existingSrc
              loadImg existingSrc
            else
              img.src = ""
              $img.hide()

        .on "keyup", ->
          unless $urlInput.val()
            if existingSrc
              loadImg existingSrc
            else
              img.src = ""
              $img.hide()

        .on "paste", ->
          setTimeout ->
            loadImg $urlInput.val()
          , 100
