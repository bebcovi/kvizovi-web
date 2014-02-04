#= require moment
#= require cookies

jQuery ->

  if $(".timer").length > 0

    timer = new App.Timer(".timer")

    App.Countdown.start timer.value(),
      onChange: (timeRemaining) =>
        timer.update(timeRemaining)
        $("[type='submit']").click() if timeRemaining == 0

    $("[type='submit']").on "click", =>
      App.Countdown.stop()

class App.Timer

  constructor: (container, @cache) ->
    @container = $(container)
    @time      = @container.find(".timer-time")
    @cache     = new @Cache(@container.data("signature"))

  update: (timeRemaining) ->
    @write(timeRemaining)

    switch
      when 5 < timeRemaining <= 10 then @turnOrange()
      when     timeRemaining <= 5  then @turnRed()

  write: (timeRemaining) ->
    @time.text moment.unix(timeRemaining).format("m:ss")
    @cache.write(timeRemaining)

  value: ->
    @cache.read() || Number(@time.data("value"))

  turnOrange: ->
    @container.addClass("text-warning")

  turnRed: ->
    @container.removeClass("text-warning").addClass("text-error")

  Cache: class

    constructor: (@signature) ->

    read: ->
      value = Number(docCookies.getItem("timeRemaining"))
      value if docCookies.getItem("signature") == @signature

    write: (value) ->
      docCookies.setItem("timeRemaining", value)
      docCookies.setItem("signature", @signature)

App.Countdown = {

  start: (seconds, @options = {}) ->
    @reset(seconds)

    @intervalId = setInterval =>
      unless @hasEnded()
        @tick()
      else
        @stop()
    , 1000

  reset: (seconds) ->
    @stop() if @isRunning()
    @setTime(seconds)

  setTime: (seconds) ->
    @timeRemaining = seconds
    @changed()

  tick: ->
    @timeRemaining -= 1
    @changed()

  changed: ->
    @options.onChange(@timeRemaining) if @options.onChange

  stop: ->
    clearInterval(@intervalId)

  isRunning: ->
    !!@intervalId

  hasEnded: ->
    @timeRemaining == 0

}
