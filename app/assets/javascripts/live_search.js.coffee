#= require moment

jQuery ->

  lastKeyup = null

  $("input[type='search']").keyup (event) ->
    lastKeyup = moment()

    unless event.keyCode == 13 # enter
      setTimeout =>
        if moment().diff(lastKeyup, "milliseconds") >= 500
          $(@).closest("form").submit()
      , 500
