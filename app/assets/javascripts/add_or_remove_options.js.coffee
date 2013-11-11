#= require ./utils/icon

jQuery ->
  new OptionsManager("choice").enable(add: "Dodaj ponuđeni odgovor")
  new OptionsManager("association").enable(add: "Dodaj asocijaciju")

class @OptionsManager

  constructor: (@name) ->
    @wrapper = $(".#{@name}-wrapper")

  enable: (options = {}) ->
    return if @wrapper.isEmpty()

    @addButton = $("<a href='#'>#{$.icon("plus")} #{options["add"] || "Dodaj"}</a>")
    @addButton.on "click", @addOption
    @wrapper.closest(".control-group").append(@addButton)

    @removeButton = $("<a class='close'>#{options["remove"] || "×"}</a>")
    @removeButton.on "click", @removeOption
    @wrapper.find(".#{@name}-remove").slice(1).append(@removeButton.clone(true))

  addOption: (event) =>
    event.preventDefault()

    $newField = @wrapper.find(".#{@name}-option").first().clone()

    $newField.find(".control-group").removeClass("success")
    $newField.find("input").val("")
    $newField.find(".#{@name}-remove").html(@removeButton.clone(true))

    @wrapper.append($newField)
    @updatePlaceholders()

  removeOption: (event) =>
    event.preventDefault()

    $(event.target).closest(".#{@name}-option").remove()
    @updatePlaceholders()

  updatePlaceholders: ->
    $(".#{@name}-option").each (idx, element) ->
      $(element).find("input").attr "placeholder", (_, value) =>
        value.replace(/\d+/, idx + 1)
