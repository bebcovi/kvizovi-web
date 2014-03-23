#= require bootstrap/tooltip
#= require bootstrap/button

jQuery ->

  new App.ImageUpload(".image_upload").enhance()

class App.ImageUpload

  constructor: (wrapper) ->
    @wrapper = $(wrapper)

    @tabs    = @wrapper.find(".image_upload-tabs").find("input")
    @tabFile = @tabs.filter("[value=file]")
    @tabUrl  = @tabs.filter("[value=url]")

    @file = new @FileUpload(@wrapper.find("#question_image"), @tabFile)
    @url  = new @UrlUpload(@wrapper.find("#question_remote_image_url"), @tabUrl)

  enhance: ->
    @preview = new @ImagePreview(@wrapper.find(".image-preview"))

    @tabs.on "change", (event) => @toggle()

    @file.tab.parent().button("toggle") # default to file input

    @file.onUpdate (input) => @preview.update(input)
    @url.onUpdate  (input) => @preview.update(input)

  toggle: ->
    if @file.isActive()
      @url.toggle("off")
      @file.toggle("on")
    else
      @file.toggle("off")
      @url.toggle("on")

  FileUpload: class

    constructor: (@field, @tab) ->

    toggle: (state) ->
      switch state
        when "on"
          @field.removeClass("sr-only")
        when "off"
          @field.val("")
          @field.addClass("sr-only")

    onUpdate: (callback) ->
      @field.on "change", (event) =>
        callback(@field[0])

    isActive: ->
      @tab.is(":checked")

  UrlUpload: class

    constructor: (@field, @tab) ->

    toggle: (state) ->
      switch state
        when "on"
          @field.removeClass("sr-only")
        when "off"
          @field.val("")
          @field.addClass("sr-only")

    onUpdate: (callback) ->
      @field.on "keyup change", (event) =>
        callback(@field[0])

    isActive: ->
      @tab.is(":checked")

  ImagePreview: class

    constructor: (value) ->
      @value = $(value)
      @originalUrl = @value.attr("src")
      @value.hide() unless @originalUrl

    update: (input) ->
      @reset() if not input.value

      switch input.type
        when "file" then @updateFromFile(input)
        when "url"  then @updateFromUrl(input)

    updateFromFile: (input) ->
      reader = new FileReader
      reader.onload = (event) =>
        url = event.target.result
        @set url
      reader.readAsDataURL input.files[0]

    updateFromUrl: (input) ->
      url = input.value
      @set url

    reset: ->
      @set @originalUrl

    set: (url) ->
      @value.attr("src", url)
      if url then @value.show() else @value.hide()
