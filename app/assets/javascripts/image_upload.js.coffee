jQuery ->

  @upload = new App.ImageUpload(".image_upload")

class App.ImageUpload

  constructor: (wrapper) ->
    @wrapper = $(wrapper)

    @tabs    = @wrapper.find(".image_upload-tabs .btn")
    @preview = new App.ImageUpload.Preview(@wrapper.find(".image-preview"))

    @file = new App.ImageUpload.File(
      tab: @tabs.first()
      input: @wrapper.find("[type='file']")
      preview: @preview
    )
    @url = new App.ImageUpload.Url(
      tab: @tabs.last()
      input: @wrapper.find("[type='url']")
      preview: @preview
    )

    @tabs.on "change", =>
      @file.update()
      @url.update()

class App.ImageUpload.Input

  constructor: (options) ->
    $.extend(@, options)
    @originalName = @input.attr("name")

    @update()
    @input.on "change", => @updatePreview()

  update: ->
    if @tab.find("input").is(":checked")
      @select()
    else
      @deselect()

  select: ->
    @input.attr("name", @originalName)
    @input.show()
    @tab.addClass("active")
    @updatePreview()

  deselect: ->
    @input.removeAttr("name")
    @input.hide()
    @tab.removeClass("active")
    @preview.reset()

  updatePreview: ->
    # overriden in subclasses

class App.ImageUpload.Url extends App.ImageUpload.Input

  constructor: (args...) ->
    super
    @input.on "keyup", =>
      lastKeyup = moment()
      setTimeout =>
        if moment().diff(lastKeyup, "milliseconds") >= 200
          @updatePreview()
      , 200

  updatePreview: ->
    if @input.val()
      @preview.set @input.val()
    else
      @preview.reset()

class App.ImageUpload.File extends App.ImageUpload.Input

  updatePreview: ->
    if @input[0].files.length
      reader = new FileReader
      reader.onload = (event) =>
        @preview.set event.target.result
      reader.readAsDataURL @input[0].files[0]
    else
      @preview.reset()

class App.ImageUpload.Preview

  constructor: (img) ->
    @img = $(img)
    @originalSrc = @img.attr("src")
    @img.hide() if not @img.attr("src")

  set: (value) ->
    @img.attr("src", value)
    @img.show()

  reset: ->
    @img.attr("src", @originalSrc)
    @img.hide() if not @originalSrc
