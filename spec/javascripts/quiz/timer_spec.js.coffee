describe "Timer", ->

  beforeEach ->
    loadFixtures("timer")
    @it = new Timer(".timer")

  describe "#update", ->

    it "writes the time to the UI", ->
      spyOn(@it, "write")
      @it.update(10)

      expect(@it.write).toHaveBeenCalled()
      expect(@it.write.mostRecentCall.args[0]).toEqual(10)

    it "turns orange when the time remaining is low", ->
      @it.update(8)
      expect($(".timer")).toHaveClass("text-warning")

    it "turns red when then time remaining is critical", ->
      @it.update(3)
      expect($(".timer")).toHaveClass("text-danger")

  describe "#write", ->

    it "displays minutes", ->
      @it.write(60)
      expect($(".timer-time")).toHaveText("1:00")

      @it.write(10)
      expect($(".timer-time")).toHaveText("0:10")

    it "displays seconds with 2 decimals", ->
      @it.write(1)
      expect($(".timer-time")).toHaveText("0:01")

  describe "#turnRed", ->

    it "removes the previous CSS class", ->
      @it.turnOrange()
      @it.turnRed()

      expect($(".timer")).toHaveAttr("class", "timer text-danger")

describe "Countdown", ->

  beforeEach ->
    jasmine.Clock.useMock()

    @it = new Countdown(
      onChange: jasmine.createSpy("onChange")
      onExpire: jasmine.createSpy("onExpire")
    )

  describe "#start", ->

    beforeEach ->
      spyOn(@it, "setTime").andCallThrough()
      @it.start(10)

    it "sets the time of the countdown", ->
      expect(@it.setTime).toHaveBeenCalled()

    it "changes every second", ->
      expect(@it.options.onChange.calls.length).toEqual(1)

      jasmine.Clock.tick(1001)
      expect(@it.options.onChange.calls.length).toEqual(2)

      jasmine.Clock.tick(1000)
      expect(@it.options.onChange.calls.length).toEqual(3)

    it "expires when the time runs out", ->
      spyOn(@it, "hasEnded").andReturn(true)
      spyOn(@it, "expire")

      jasmine.Clock.tick(1001)

      expect(@it.expire).toHaveBeenCalled()

    it "doesn't go below zero", ->
      jasmine.Clock.tick(20 * 1000)

      expect(@it.timeRemaining).toEqual(0)

  describe "#setTime", ->

    beforeEach ->
      @it.setTime(10)

    it "sets the length of the countdown", ->
      expect(@it.timeRemaining).toEqual(10)

  describe "#decrement", ->

    beforeEach ->
      @it.setTime(10)

    it "decrements the time remaining", ->
      @it.decrement()
      expect(@it.timeRemaining).toEqual(9)

  describe "#expire", ->

    beforeEach ->
      @it.start(10)

    it "terminates execution", ->
      @it.expire()
      jasmine.Clock.tick(1001)

      expect(@it.options.onChange.calls.length).toEqual(1)

  describe "#hasEnded", ->

    it "is true when the time run out", ->
      @it.start(10)
      jasmine.Clock.tick(9001)

      expect(@it.hasEnded()).toEqual(false)

      jasmine.Clock.tick(1000)

      expect(@it.hasEnded()).toEqual(true)
