describe "OptionsManager", ->

  for category in ["choice", "association"]

    context "for #{category}", do (category) -> ->

      beforeEach do (category) -> ->
        loadFixtures("questions/#{category}_form")

        @it = new OptionsManager(category)
        @it.enable()

        @addButton = $("a").last()
        @removeButtons = $(".close")
        @options = -> $(".#{category}-option")

      describe "#enable", ->

        it "adds the \"add\" button", ->
          expect(@addButton).toExist()

        it "adds \"remove\" buttons to all options but first", ->
          @options().slice(1).each (_, option) ->
            expect(option).toContain(".close")
          expect(@options().first()).not.toContain("close")

      describe "#addOption", ->

        it "prevents default event", ->
          spyOnEvent(@addButton, "click")
          @addButton.click()
          expect("click").toHaveBeenPreventedOn(@addButton)

        it "adds a new option", ->
          previousLength = @options().length
          @addButton.click()
          expect(@options()).toHaveLength(previousLength + 1)

        it "removes the \"success\" class from the added option", ->
          @addButton.click()
          expect(@options().last()).not.toHaveClass("success")

        it "removes input values", ->
          @addButton.click()
          @options().last().find("input").each (_, input) =>
            expect(input).toHaveValue("")

        it "adds the remove button", ->
          @addButton.click()
          expect(@options().last()).toContain(".close")

        it "updates the placeholder", ->
          @addButton.click()
          @options().last().find("input").each (_, input) =>
            expect(input.placeholder).toMatch(@options().length)

      describe "#removeOption", ->

        it "prevents default behaviour", ->
          removeButton = @removeButtons.first()
          spyOnEvent(removeButton, "click")
          removeButton.click()
          expect("click").toHaveBeenPreventedOn(removeButton)

        it "removes the option", ->
          previousLength = @options().length
          @removeButtons.first().click()
          expect(@options()).toHaveLength(previousLength - 1)

        it "updates the placeholders", ->
          $(@removeButtons[-2]).click()
          @options().last().find("input").each (_, input) =>
            expect(input.placeholder).toMatch(@options().length)
