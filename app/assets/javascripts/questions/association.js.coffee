do ($ = jQuery) ->

  App.Questions.association =

    play: ($form) ->

      $table    = $("table.js-hidden")
      $pairs    = $(".association-pair", $form)

      $static   = $(".association-pair-static", $pairs)
      $dynamic  = $(".association-pair-dynamic", $pairs)

      swap = ($one, $two) ->
        $oneParent = $one.parent()
        $twoParent = $two.parent()

        $one.prependTo $twoParent
        $two.prependTo $oneParent

        $one.next().attr "value", $one.text()
        $two.next().attr "value", $two.text()

      $table.removeClass("js-hidden")

      $pairs.find("input").each ->
        $el = $("<span>").text $(@).val()
        $(@).before $el
        $(@).hide()

      $dynamic.find("span")
        .addClass("is-unselectable")

        .draggable
          addClasses:     false
          revert:         "invalid"
          revertDuration: 250
          helper:         "clone"
          zIndex:         10
          start: -> $(@).addClass "association-pair-original"
          stop:  -> $(@).removeClass "association-pair-original"

        .droppable
          addClasses: false
          hoverClass: "association-pair-hover"
          drop: (e, ui) -> swap($(@), ui.draggable)
