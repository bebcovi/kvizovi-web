jQuery ->

  new GameSpecification("#new_game_specification").stepenize()

class GameSpecification

  constructor: (wrapper) ->
    @wrapper = $(wrapper)

    @quiz   = new @Quiz(@wrapper.find(".quizzes"))
    @player = new @Player(@wrapper.find(".players"))
    @login  = new @Login(@wrapper.find(".login"))
    @start  = new @Start(@wrapper.find(".btn-toolbar"))

  stepenize: ->
    @quiz  .visible => true
    @player.visible => @quiz.isSelected()
    @login .visible => @player.isSelected() and @player.count() == 2
    @start .visible => @player.isSelected()

    @start.setQuiz @quiz.name() if @quiz.isSelected()

    @wrapper.on "change", => @stepenize()

  Component: class

    constructor: (value) ->
      @value = $(value)

    visible: (condition) =>
      if condition() then @value.show() else @value.hide()

  Quiz: class extends @prototype.Component

    isSelected: ->
      @value.find(":checked").length > 0

    name: ->
      @value.find(":checked").closest("label").text().trim()

  Player: class extends @prototype.Component

    constructor: (value) ->
      super

    isSelected: ->
      @value.find(":checked").length > 0

    count: ->
      Number(@value.find(":checked").val()) if @isSelected()

  Login: class extends @prototype.Component

  Start: class extends @prototype.Component

    setQuiz: (name) ->
      @value.find("[type='submit']")
        .html("Započni kviz <strong>#{name}</strong>!")

@GameSpecification = GameSpecification
