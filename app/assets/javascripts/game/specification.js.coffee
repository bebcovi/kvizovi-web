jQuery ->

  new GameSpecification("#new_game_specification").activate()

class @GameSpecification

  constructor: (wrapper) ->
    @wrapper = $(wrapper)
    @quizzes = @wrapper.find(".quizzes")
    @players = @wrapper.find(".players")
    @login   = @wrapper.find(".login")
    @buttons = @wrapper.find(".btn-toolbar")

  activate: ->
    return if @wrapper.isEmpty()

    @quizzes.show()

    @players.hide() if @quizzes.find(":checked").isEmpty()
    @quizzes.on "change", => @players.show()

    @login.hide() unless @players.find(":checked").val() == "2"
    @players.on "change", (event) =>
      switch event.target.value
        when "1" then @login.hide()
        when "2" then @login.show()

    @buttons.hide() if @players.find(":checked").isEmpty()
    @quizzes.on "change", (event) =>
      quizName = $(event.target).closest("label").text().trim()
      @buttons.find("[type='submit']")
        .html("Započni kviz <strong>#{quizName}</strong>!")
    @players.on "change", => @buttons.show()
