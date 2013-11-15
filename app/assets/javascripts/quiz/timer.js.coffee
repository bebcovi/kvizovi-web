#= require moment
#= require cookies

jQuery ->

  countdownCache = new CountdownCache(docCookies)

  countdown = new Countdown(
    onChange: (timeRemaining) ->
      new Timer(".timer").update(timeRemaining)
      countdownCache.set(timeRemaining)
    onExpire: ->
      $("[type='submit']").click()
  )

  unless $(".timer").isEmpty()
    countdown.start(countdownCache.get() || 60)
    $("[type='submit']").on "click", -> countdownCache.clear()
  else
    countdownCache.clear()

class CountdownCache

  constructor: (@store) ->

  set: (value) ->
    @store.setItem(@key, value)

  get: ->
    @store.getItem(@key)

  clear: ->
    @store.removeItem(@key)
    null

  key: "timeRemaining"

class @Timer

  constructor: (container) ->
    @container = $(container)
    @time      = @container.find(".timer-time")

  update: (timeRemaining) ->
    @write(timeRemaining)

    switch
      when 5 < timeRemaining <= 10 then @turnOrange()
      when     timeRemaining <= 5  then @turnRed()

  write: (timeRemaining) ->
    @time.text moment.unix(timeRemaining).format("m:ss")

  turnOrange: ->
    @container.addClass("text-warning")

  turnRed: ->
    @container.removeClass("text-warning").addClass("text-error")

class @Countdown

  constructor: (@options = {}) ->

  start: (seconds) ->
    @setTime(seconds)

    @change()

    @intervalId = setInterval =>
      if @hasEnded()
        @expire()
      else
        @decrement()
    , 1000

  setTime: (seconds) ->
    @timeRemaining = seconds

  decrement: ->
    @timeRemaining -= 1
    @change()

  change: ->
    @options.onChange(@timeRemaining) if @options.onChange

  expire: ->
    clearInterval(@intervalId)
    @options.onExpire() if @options.onExpire

  hasEnded: ->
    @timeRemaining <= 0
