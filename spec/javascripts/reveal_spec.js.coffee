describe "ContentReveal", ->

  beforeEach ->
    loadFixtures("reveal")

    @it = new ContentReveal(".reveal-content")
    @it.enable()

    @content = $(".reveal-content")
    @button  = $(".reveal-toggle")

  describe "#enable", ->

    it "hides the content", ->
      expect(@content).toBeHidden()

    it "shows the content on button click", ->
      @button.click()
      expect(@content).toBeVisible()

    it "hides the button on button click", ->
      @button.click()
      expect(@button).toBeHidden()
