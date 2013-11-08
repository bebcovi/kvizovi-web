#= require image_upload

describe "ImageUpload", ->

  beforeEach ->
    loadFixtures("image_upload")
    @it = new ImageUpload(".question_image")
    @file = $(".question_image").children().slice(0, 3)
    @url = $(".question_image").children().slice(3, 6)

  describe "#constructor", ->

    it "adds the icons", ->
      expect($("label.file").prev()).toContain(".icon-storage")
      expect($("label.url").prev()).toContain(".icon-link")

  describe "#enhance", ->

    it "shows the file input by default", ->
      @it.enhance()
      expect(@file).toBeVisible()
      expect(@url).toBeHidden()

    it "shows the url input if present", ->
      $("input.url").val("http://example.jpg")
      @it.enhance()
      expect(@url).toBeVisible()
      expect(@file).toBeHidden()

  describe "#toggleButton", ->

    it "clears the URL field on toggle", ->
      $("input.url").val("http://example.jpg")
      @it.enhance()
      $(".toggle-type").click()
      expect($("input.url")).toHaveValue("")
