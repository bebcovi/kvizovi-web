#= require ./utils/icon
#= require twitter/bootstrap/tooltip

jQuery ->

  new ImageUpload(".question_image").enhance()

class @ImageUpload

  constructor: (wrapper) ->
    @wrapper = $(wrapper)

    $("label.file").before @toggleButton()
      .attr("title", "Na računalu")
      .html($.icon("storage"))
    @file = @wrapper.children().slice(0, 3)

    $("label.url").before @toggleButton()
      .attr("title", "Na internetu")
      .html($.icon("link"))
    @url = @wrapper.children().slice(3, 6)

    $(".toggle-type").tooltip()

  enhance: ->
    return if @wrapper.isEmpty()

    if @isUrlActive() then @file.hide() else @url.hide()
    @file.on "change", @updatePreview
    @url.on "change", @updatePreview

  updatePreview: (event) =>
    input = event.target

    switch input.type
      when "file"
        reader = new FileReader
        reader.onload = (event) =>
          imageURL = event.target.result
          @previewImage imageURL
        reader.readAsDataURL input.files[0]
      when "url"
        imageURL = input.value
        @previewImage imageURL

  previewImage: (url) ->
    $(".image-preview").attr("src", url)

  isUrlActive: ->
    @url.find("input").val()

  toggleButton: ->
    $("<a href='#' class='btn toggle-type'>")
      .on "click", (event) =>
        event.preventDefault()
        @file.toggle()
        @url.toggle()
          .find("input").val("")
