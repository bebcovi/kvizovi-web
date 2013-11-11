jQuery ->

  new QuizSpecification("#new_quiz_specification").activate()

class @QuizSpecification

  constructor: (wrapper) ->
    @wrapper = $(wrapper)
    @quizzes = @wrapper.find(".quizzes")
    @players = @wrapper.find(".players")
    @login   = @wrapper.find(".login")
    @buttons = @wrapper.find(".btn-toolbar")

  activate: ->
    return if @wrapper.isEmpty()

    @quizzes.show()

    @players.hide()
    @quizzes.on "change", => @players.show()

    @login.hide()
    @players.on "change", (event) =>
      switch event.target.value
        when "1" then @login.hide()
        when "2" then @login.show()

    @buttons.hide()
    @quizzes.on "change", (event) =>
      quizName = $(event.target).closest("label").text().trim()
      @buttons.find("[type='submit']")
        .html("Započni kviz <strong>#{quizName}</strong>!")
    @players.on "change", => @buttons.show()
