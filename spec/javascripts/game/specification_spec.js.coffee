describe "GameSpecification", ->

  beforeEach ->
    loadFixtures("game/specification")

    @it = new GameSpecification("#new_game_specification")
    @it.activate()

    @quizzes = $(".quizzes")
    @players = $(".players")
    @login   = $(".login")
    @buttons = $(".btn-toolbar")

  describe "#activate", ->

    it "hides everything but quizzes", ->
      expect(@quizzes).toBeVisible()
      expect(@players).toBeHidden()
      expect(@login).toBeHidden()
      expect(@buttons).toBeHidden()

    context "when quiz is chosen", ->

      beforeEach ->
        @quizzes.find("input[type='radio']").first().click()

      it "shows players", ->
        expect(@players).toBeVisible()

      it "adds the name of the quiz to the button", ->
        expect(@buttons.find("[type='submit']")).toHaveText("Započni kviz Antigona!")

    context "when single player is chosen", ->

      beforeEach ->
        @quizzes.find("input[type='radio']").click()
        @players.find("input[type='radio']").first().click()

      it "doesn't show login", ->
        expect(@login).toBeHidden()

      it "shows the begin button", ->
        expect(@buttons).toBeVisible()

    context "when multi player is chosen", ->

      beforeEach ->
        @quizzes.find("input[type='radio']").click()
        @players.find("input[type='radio']").last().click()

      it "shows login", ->
        expect(@login).toBeVisible()

      it "shows the begin button", ->
        expect(@buttons).toBeVisible()
