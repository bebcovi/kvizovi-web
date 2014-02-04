specs = (category) ->

  describe "OptionList", ->

    beforeEach ->
      loadFixtures("questions/#{category}_form")
      @wrapper = $(".#{category}-wrapper")

      @subject = new App.OptionList(@wrapper)

      @addButton = @wrapper.closest(".control-group").children("a")
      @options   = -> @wrapper.find(".#{category}-option")

    describe "#constructor", ->

      it "adds the \"add\" button", ->
        expect(@addButton).toExist()

      it "adds \"remove\" buttons to all options but first", ->
        @options().slice(1).each (_, option) =>
          expect(option).toContain(".close")
        expect(@options().first()).not.toContain(".close")

      it "adds a new option when the \"add\" button is clicked", ->
        previousLength = @options().length
        @addButton.click()
        expect(@options()).toHaveLength(previousLength + 1)

      it "removes the option when the \"remove\" button is clicked", ->
        $option = @options().last()
        $option.find(".close").click()

    describe "#add", ->

      beforeEach ->
        @newOption = @options().last().clone()

      it "appends the new option to the DOM", ->
        @subject.add(@newOption)
        expect(@newOption).toExist()

      it "reinitializes the options", ->
        spyOn(@subject, "initializeOptions")
        @subject.add(@newOption)
        expect(@subject.initializeOptions).toHaveBeenCalled()

    describe "#remove", ->

      beforeEach ->
        @option = @options().last()

      it "removes the option from the DOM", ->
        @subject.remove(@option)
        expect(@option).not.toExist()

      it "reinitializes the options", ->
        spyOn(@subject, "initializeOptions")
        @subject.remove(@option)
        expect(@subject.initializeOptions).toHaveBeenCalled()

    describe "#newOption", ->

      beforeEach ->
        @newOption = @subject.newOption()

      it "removes the \"success\" class", ->
        expect(@newOption).not.toContain(".success")

      it "removes any \"remove\" buttons", ->
        expect(@newOption.find(".#{category}-remove")[0].innerHTML).toEqual("")

      it "clears the input value", ->
        expect(@newOption.find("input")).toHaveValue("")

    describe "#initializeOptions", ->

      it "doesn't touch the first option", ->
        expect(@options().first()).not.toContain(".close")

      it "assigns the right positions", ->
        @options().each (idx, option) ->
          expect($(option).find("input").attr("placeholder")).toMatch(idx + 1)

    describe "#addButton", ->

      it "prevents the default click", ->
        event = spyOnEvent(@addButton, "click")
        @addButton.click()
        expect(event).toHaveBeenPrevented()

      it "triggers an event on click", ->
        spyOnEvent(@wrapper, "option:add")
        @addButton.click()
        expect("option:add").toHaveBeenTriggeredOn(@wrapper)

    describe "Option", ->

      App.OptionList.Option = App.OptionList.prototype.Option

      beforeEach ->
        @option  = @options().first()
        @subject = new App.OptionList.Option(@option, 1)

      describe "#constructor", ->

        it "adds the \"remove\" button", ->
          new App.OptionList.Option(@option)
          expect(@option).toContain(".close")

        it "updates the placeholder", ->
          new App.OptionList.Option(@option, 1)
          @option.find("input").each (_, input) =>
            expect(input.placeholder).toMatch(/1/)

          new App.OptionList.Option(@option, 10)
          @option.find("input").each (_, input) =>
            expect(input.placeholder).toMatch(/10/)

      describe "#removeButton", ->

        it "triggers an event on click", ->
          spyOnEvent(@wrapper, "option:remove")
          @option.find(".close").click()
          expect("option:remove").toHaveBeenTriggeredOn(@wrapper)

        it "prevents the default click", ->
          event = spyOnEvent(@option.find(".close"), "click")
          @option.find(".close").click()
          expect(event).toHaveBeenPrevented()

specs("choice")
specs("association")
