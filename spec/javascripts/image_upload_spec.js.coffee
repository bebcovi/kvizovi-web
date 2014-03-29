describe "ImageUpload", ->

  beforeEach ->
    loadFixtures("image_upload")
    @wrapper = $(".image_upload")

    @subject = new App.ImageUpload(@wrapper)

    @tabs    = @wrapper.find(".image_upload-tabs .btn")

    @file    = @wrapper.find("input[type='file']")
    @url     = @wrapper.find("input[type='url']")

    @preview = @wrapper.find(".image-preview")

  describe "#constructor", ->

    it "triggers the update of file and url on tab change", ->
      spyOn(@subject.file, "update")
      spyOn(@subject.url, "update")

      @tabs.find("input").trigger("change")

      expect(@subject.file.update).toHaveBeenCalled()
      expect(@subject.url.update).toHaveBeenCalled()

  describe ".Input", ->

    beforeEach ->
      @subject = new App.ImageUpload.Input(
        tab: @tabs.last()
        input: @url
        preview: new App.ImageUpload.Preview(@preview)
      )

    describe "#constructor", ->

      it "calls #update", ->
        @tabs.last().find("input").attr("checked", true)
        new App.ImageUpload.Input(
          tab: @tabs.last()
          input: @url
          preview: new App.ImageUpload.Preview(@preview)
        )
        expect(@url).toBeVisible()

      it "updates the preview on input change", ->
        spyOn(@subject, "updatePreview")
        @url.trigger("change")
        expect(@subject.updatePreview).toHaveBeenCalled()

      it "saves the original name", ->
        expect(@subject.originalName).not.toBeEmpty()

    describe "#update", ->

      it "calls #select when the input is checked", ->
        @tabs.last().find("input").attr("checked", true)
        spyOn(@subject, "select")
        @subject.update()
        expect(@subject.select).toHaveBeenCalled()

      it "calls #deselect when the input is not checked", ->
        @tabs.last().find("input").removeAttr("checked")
        spyOn(@subject, "deselect")
        @subject.update()
        expect(@subject.deselect).toHaveBeenCalled()

    describe "#select", ->

      it "assigns the name to the original name", ->
        @subject.select()
        expect(@url.attr("name")).not.toBeEmpty()

      it "shows the input", ->
        @subject.select()
        expect(@url).toBeVisible()

      it "makes the tab active", ->
        @subject.select()
        expect(@tabs.last()).toHaveClass("active")

      it "updates the preview", ->
        spyOn(@subject, "updatePreview")
        @subject.select()
        expect(@subject.updatePreview).toHaveBeenCalled()

    describe "#deselect", ->

      it "clears the name of the input", ->
        @subject.deselect()
        expect(@url).not.toHaveAttr("name")

      it "hides the input", ->
        @subject.deselect()
        expect(@url).toBeHidden()

      it "makes the tab inactive", ->
        @subject.deselect()
        expect(@tabs.last()).not.toHaveClass("active")

      it "resets the preview", ->
        spyOn(@subject.preview, "reset")
        @subject.deselect()
        expect(@subject.preview.reset).toHaveBeenCalled()

  describe ".Preview", ->

    beforeEach ->
      @subject = new App.ImageUpload.Preview(@preview)

    describe "#constructor", ->

      it "hides the preview if the src is empty", ->
        @preview.attr("src", "")
        new App.ImageUpload.Preview(@preview)
        expect(@preview.css("display")).toEqual("none")

      it "saves the src as original src", ->
        @preview.attr("src", "foo")
        @subject = new App.ImageUpload.Preview(@preview)
        expect(@subject.originalSrc).toEqual("foo")

    describe "#set", ->

      it "updates the src with the given value", ->
        @subject.set("foo")
        expect(@preview.attr("src")).toEqual("foo")

      it "shows the preview", ->
        @subject.set("foo")
        expect(@preview.css("display")).not.toEqual("none")

    describe "#reset", ->

      it "resets the src with the original value", ->
        @subject.originalSrc = "foo"
        @subject.reset()
        expect(@preview.attr("src")).toEqual("foo")

      it "hides the preview if there is no original value", ->
        @subject.originalSrc = ""
        @subject.reset()
        expect(@preview.css("display")).toEqual("none")
