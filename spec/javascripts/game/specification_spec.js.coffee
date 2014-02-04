describe "GameSpecification", ->

  beforeEach ->
    loadFixtures("game/specification")

    @subject = new App.GameSpecification("#new_game_specification")
    @subject.stepenize()

    @quizzes = $(".quizzes")
    @players = $(".players")
    @login   = $(".login")
    @buttons = $(".btn-toolbar")

    @chooseQuiz = ->
      @quizzes.find("[type='radio']").click()

    @choosePlayers = (number) ->
      @players.find("[type='radio'][value='#{number}']").click()

  describe "#stepenize", ->

    it "always shows quizzes", ->
      expect(@quizzes).toBeVisible()

    it "shows players when a quiz is selected", ->
      expect(@players).toBeHidden()
      @chooseQuiz()
      expect(@players).toBeVisible()

    it "shows login when multiplayer is selected", ->
      @chooseQuiz()
      expect(@login).toBeHidden()
      @choosePlayers(1)
      expect(@login).toBeHidden()
      @choosePlayers(2)
      expect(@login).toBeVisible()

    it "shows buttons when players are selected", ->
      @chooseQuiz()
      expect(@buttons).toBeHidden()
      @choosePlayers(1)
      expect(@buttons).toBeVisible()

    it "assigns the name of the quiz to the \"start\" button", ->
      @chooseQuiz()
      expect(@buttons.find("[type='submit']")).toHaveText("Započni kviz Antigona!")
