describe "ImageUpload", ->

  beforeEach ->
    loadFixtures("image_upload")
    @wrapper = $(".question_image")

    @subject = new App.ImageUpload(@wrapper)

    @file = @wrapper.children().slice(0, 3)
    @url = @wrapper.children().slice(3, 6)
    @preview = @wrapper.find(".image-preview")

  describe "#constructor", ->

    it "initializes the file upload", ->
      expect(@file.first()).toBe(".toggle-type")

    it "initializes the url upload", ->
      expect(@url.first()).toBe(".toggle-type")

  describe "#enhance", ->

    beforeEach ->
      @subject.enhance()

    it "shows the file input by default", ->
      expect(@file).toBeVisible()
      expect(@url).toBeHidden()

    it "shows the url input if it's present", ->
      @url.filter("input").val("http://example.jpg")
      @url.show()
      @subject.enhance()
      expect(@url).toBeVisible()
      expect(@file).toBeHidden()

    it "switches the type on icon click", ->
      spyOn(@subject, "switchType")
      @wrapper.find(".toggle-type").first().click()
      expect(@subject.switchType).toHaveBeenCalled()

    it "updates the preview on file change", ->
      spyOn(@subject.preview, "update")
      @file.filter("input").trigger("change")
      expect(@subject.preview.update).toHaveBeenCalled()

    it "updates the preview on url change", ->
      spyOn(@subject.preview, "update")
      @url.filter("input").trigger($.Event("keyup"))
      expect(@subject.preview.update).toHaveBeenCalled()

  describe "#switchType", ->

    beforeEach ->
      @subject.enhance()

    it "switches the type", ->
      @subject.switchType()
      expect(@file).toBeHidden()
      expect(@url).toBeVisible()

      @subject.switchType()
      expect(@file).toBeVisible()
      expect(@url).toBeHidden()

    it "resets the preview", ->
      @url.filter("input").val "http://example.jpg"
      @subject.switchType()
      expect(@preview).not.toHaveAttr("src")

  describe "FileUpload", ->

    beforeEach ->
      @subject = @subject.file

    describe "#constructor", ->

      it "creates a toggle button", ->
        expect(@subject.fields.first()).toBe(".toggle-type")

    describe "#toggle", ->

      it "changes the visibility", ->
        @subject.toggle()
        expect(@subject.fields).toBeHidden()
        @subject.toggle()
        expect(@subject.fields).toBeVisible()

      # Assigning value to a file manually throws InvalidStateError, for
      # security reasons. There doesn't seem to be any way around this.
      it "clears the input value", ->
        # @subject.fields.find("input")[0].val("foobar")
        @subject.toggle()
        expect(@subject.fields.filter("input")).toHaveValue("")

    describe "#update", ->

      it "triggers the callback on change", ->
        callback = jasmine.createSpy("callback")
        @subject.onUpdate callback
        @subject.fields.filter("input").trigger("change")

        expect(callback).toHaveBeenCalled()
        expect(callback).toHaveBeenCalledWith(jasmine.any(HTMLInputElement))

  describe "UrlUpload", ->

    beforeEach ->
      @subject = @subject.url

    describe "#constructor", ->

      it "creates a toggle button", ->
        expect(@subject.fields.first()).toBe(".toggle-type")

    describe "#toggle", ->

      it "changes the visibility", ->
        @subject.toggle()
        expect(@subject.fields).toBeHidden()
        @subject.toggle()
        expect(@subject.fields).toBeVisible()

      it "clears the input value", ->
        @subject.fields.filter("input").val("foo")
        @subject.toggle()
        expect(@subject.fields.filter("input")).toHaveValue("")

    describe "#update", ->

      it "triggers the callback on keyup", ->
        callback = jasmine.createSpy("callback")
        @subject.onUpdate callback
        @subject.fields.filter("input").trigger($.Event("keyup"))

        expect(callback).toHaveBeenCalled()
        expect(callback).toHaveBeenCalledWith(jasmine.any(HTMLInputElement))

  describe "ImagePreview", ->

    beforeEach ->
      @subject.enhance()
      @subject = @subject.preview

    describe "#constructor", ->

      it "hides the preview if the URL is empty", ->
        expect(@subject.value).toBeHidden()

    describe "#update", ->

      beforeEach ->
        spyOn(@subject, "updateFromFile")
        spyOn(@subject, "updateFromUrl")

      it "updates from file on file inputs", ->
        input = $("<input>", type: "file")[0]
        @subject.update(input)
        expect(@subject.updateFromFile).toHaveBeenCalled()

      it "updates from url on url inputs", ->
        input = $("<input>", type: "url")[0]
        @subject.update(input)
        expect(@subject.updateFromUrl).toHaveBeenCalled()

      it "resets if the user removes the attached file", ->
        @subject.originalUrl = "jasmine"
        input = $("<input>", type: "file")[0]
        @subject.update(input)
        expect(@subject.value).toHaveAttr("src", "jasmine")

    describe "#reset", ->

      it "shows the preview of the original URL", ->
        @subject.originalUrl = "jasmine"
        @subject.reset()
        expect(@subject.value).toHaveAttr("src", "jasmine")

    describe "#set", ->

      it "assigns the URL", ->
        @subject.set("jasmine")
        expect(@subject.value).toHaveAttr("src", "jasmine")

      it "shows the preview if the URL is present", ->
        @subject.set("favicon.ico")
        expect(@subject.value).toBeVisible()

      it "hides the preview if the URL is blank", ->
        @subject.set("")
        expect(@subject.value).toBeHidden()
