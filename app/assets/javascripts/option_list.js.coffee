jQuery ->

  new App.OptionList(".choice-wrapper",      add: "Dodaj ponuđeni odgovor")
  new App.OptionList(".association-wrapper", add: "Dodaj asocijaciju")

class App.OptionList

  constructor: (wrapper, params = {}) ->
    @wrapper = $(wrapper)
    @initializeOptions()
    @wrapper.closest(".control-group").append @addButton(params["add"])

    @wrapper.on "option:add",    (_, option) => @add option
    @wrapper.on "option:remove", (_, option) => @remove option

  add: (option) ->
    @wrapper.append $(option)
    @initializeOptions()

  remove: (option) ->
    $(option).remove()
    @initializeOptions()

  newOption: ->
    @wrapper.find("[class$='option']").first().clone()
      .find(".control-group").removeClass("success").end()
      .find("[class$='remove']").html("").end()
      .find("input").val("").end()

  initializeOptions: ->
    @wrapper.find("[class$='option']")
      .each (idx, option) =>
        new @Option(option, idx + 1) unless idx == 0

  addButton: (text) ->
    $("<a>", href: "#", html: "#{$.icon("plus")} #{text}")
      .on "click", (event) =>
        event.preventDefault()
        @wrapper.trigger("option:add", @newOption())

  Option: class

    constructor: (value, @position) ->
      @value = $(value)
      @value.find("[class$='remove']").html @removeButton("×")
      @value.find("input").attr "placeholder", (_, placeholder) =>
        placeholder.replace(/\d+/, @position)

    removeButton: (text) ->
      $("<a>", class: "close", text: text)
        .on "click", (event) =>
          event.preventDefault()
          @value.trigger("option:remove", @value)
