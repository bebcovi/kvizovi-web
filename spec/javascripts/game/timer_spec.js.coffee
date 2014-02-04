describe "Timer", ->

  beforeEach ->
    loadFixtures("timer")
    @subject = new App.Timer(".timer")
    @timer = $(".timer")
    @time = @timer.find(".timer-time")

  afterEach ->
    docCookies.removeItem("timeRemaining")
    docCookies.removeItem("signature")

  describe "#update", ->

    it "writes the time to the UI", ->
      @subject.update(10)
      expect(@time).toHaveText("0:10")

    it "turns orange when the time remaining is low", ->
      @subject.update(8)
      expect(@timer).toHaveClass("text-warning")

    it "turns red when then time remaining is critical", ->
      @subject.update(3)
      expect(@timer).toHaveClass("text-error")

  describe "#write", ->

    it "displays minutes", ->
      @subject.write(60)
      expect(@time).toHaveText("1:00")

      @subject.write(10)
      expect(@time).toHaveText("0:10")

    it "displays seconds with 2 decimals", ->
      @subject.write(1)
      expect(@time).toHaveText("0:01")

    it "writes to the cache", ->
      @subject.write(60)
      @time.text("")
      expect(@subject.value()).toEqual(60)

  describe "#value", ->

    it "reads from the HTML attributes", ->
      expect(@subject.value()).toEqual(60)

    it "reads from cache if available", ->
      @subject.write(15)
      expect(@subject.value()).toEqual(15)

  describe "#turnRed", ->

    it "removes the previous CSS class", ->
      @subject.turnOrange()
      @subject.turnRed()

      expect($(".timer")).toHaveAttr("class", "timer text-error")

  describe "Cache", ->

    beforeEach ->
      @subject = new App.Timer.prototype.Cache("foo")
      docCookies.setItem("signature", "foo")

    describe "#read", ->

      it "reads time from the cookie", ->
        docCookies.setItem("timeRemaining", 15)
        expect(@subject.read()).toEqual(15)

      it "returns null if the signatures don't match", ->
        docCookies.setItem("timeRemaining", 15)
        docCookies.setItem("signature", "bar")
        expect(@subject.read()).toBeFalsy()

    describe "#write", ->

      it "writes time to the cookie", ->
        @subject.write(15)
        expect(@subject.read()).toEqual(15)

      it "writes the signature to the cookie", ->
        docCookies.setItem("signature", "bar")
        @subject.write(15)
        expect(@subject.read()).toEqual(15)

describe "Countdown", ->

  beforeEach ->
    jasmine.Clock.useMock()
    @subject = App.Countdown

  describe ".start", ->

    beforeEach ->
      @subject.start(10, onChange: jasmine.createSpy("onChange"))
      jasmine.Clock.tick(1)

    it "sets the time of the countdown", ->
      expect(@subject.timeRemaining).toEqual(10)

    it "stops the potential running", ->
      @subject.start(10, onChange: @subject.options.onChange)
      calls = @subject.options.onChange.calls.length
      jasmine.Clock.tick(1000)
      expect(@subject.options.onChange.calls.length).toEqual(calls + 1)

    it "ticks every second", ->
      spyOn(@subject, "tick")

      jasmine.Clock.tick(1000)
      expect(@subject.tick.calls.length).toEqual(1)

      jasmine.Clock.tick(1000)
      expect(@subject.tick.calls.length).toEqual(2)

    it "stops when it has reached 0", ->
      jasmine.Clock.tick(10 * 1000)
      expect(@subject.timeRemaining).toEqual(0)

      jasmine.Clock.tick(1 * 1000)
      expect(@subject.timeRemaining).toEqual(0)

  describe ".setTime", ->

    it "sets the length of the countdown", ->
      @subject.setTime(10)
      expect(@subject.timeRemaining).toEqual(10)

    it "triggers the change", ->
      spyOn(@subject, "changed")
      @subject.setTime(10)
      expect(@subject.changed).toHaveBeenCalled()

  describe ".tick", ->

    beforeEach ->
      @subject.setTime(10)

    it "decrements the time remaining", ->
      @subject.tick()
      expect(@subject.timeRemaining).toEqual(9)

    it "triggers the change", ->
      spyOn(@subject, "changed")
      @subject.tick()
      expect(@subject.changed).toHaveBeenCalled()

  describe ".stop", ->

    beforeEach ->
      @subject.start(10)
      jasmine.Clock.tick(1)

    it "stops the countdown", ->
      @subject.stop()
      jasmine.Clock.tick(1000)
      expect(@subject.timeRemaining).toEqual(10)

  describe ".hasEnded", ->

    beforeEach ->
      @subject.start(10)
      jasmine.Clock.tick(1)

    it "returns false when the countdown hasn't ended", ->
      expect(@subject.hasEnded()).toEqual(false)

    it "returns true when the countdown has ended", ->
      jasmine.Clock.tick(10 * 1000)
      expect(@subject.hasEnded()).toEqual(true)

  describe ".changed", ->

    beforeEach ->
      @subject.start(10, onChange: jasmine.createSpy("onChange"))

    it "triggers onChange", ->
      calls = @subject.options.onChange.calls.length
      @subject.changed()
      expect(@subject.options.onChange.calls.length).toEqual(calls + 1)
