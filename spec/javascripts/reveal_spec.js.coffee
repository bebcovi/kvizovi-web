describe "Content", ->

  beforeEach ->
    loadFixtures("reveal")

    @subject = new App.Content(".reveal-content")
    @subject.hide()

    @content = $(".reveal-content")
    @button  = $(".reveal-toggle")

  describe "#hide", ->

    it "hides the content", ->
      expect(@content).toBeHidden()

    it "creates the \"show\" button", ->
      expect(@button).toExist()

  describe "#reveal", ->

    beforeEach ->
      @subject.reveal()

    it "it shows the content", ->
      expect(@content).toBeVisible()

    it "hides the button", ->
      expect(@button).toBeHidden()
