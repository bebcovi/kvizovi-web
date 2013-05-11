do ($ = jQuery) ->

  $(".dropdown-hover")
    .on "mouseenter", ->
      unless $(@).hasClass("open")
        $(@).find(".dropdown-toggle")
          .dropdown("toggle")

    .on "mouseleave", ->
      if $(@).hasClass("open")
        $(@).find(".dropdown-toggle")
          .dropdown("toggle")
          .blur()
