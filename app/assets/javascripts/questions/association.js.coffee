do ($ = jQuery) ->

  App.Questions.association =

    design: ($form) ->

      $pairs        = $(".association-pair", $form)

      $firstPair    = $pairs.first()
      $otherPairs   = $firstPair.siblings(".association-pair")
      $template     = $firstPair.clone()

      $wrapper      = $firstPair.parent()
      $addButton    = $.addButton.clone()

      updateAttrs   = ($el, i) ->
        i += 2
        j = i * 2

        $el.find("input").each (index) ->

          $input = $(@)

          id = $input.attr("id")
          placeholder = $input.attr("placeholder")

          $input.attr "id",           id.replace(/\d+/, if index is 1 then j else j - 1)
          $input.attr "placeholder",  placeholder.replace(/\d+/, i)

      addPair = ($el) ->
        $otherPairs = $otherPairs.add $el.insertAfter($otherPairs)

      removePair = ($el) ->
        $otherPairs = $otherPairs.not $el.remove()

      filled = ($el) ->
        result = true
        $el.find("input").each -> result = result and !!$(@).val()
        result

      $otherPairs.add($template).children(":last-child")
        .after $.removeButton
          .clone()
          .addClass("close")
          .attr("tabindex", -1)

      $template
        .find("input").val("").end()
        .find("div").removeClass("field_with_errors").end()
        .find(".error").remove()

      $addButton.appendTo($wrapper)

      $addButton
        .on "click", (event) ->
          $new = $template.clone()
          event.preventDefault()
          updateAttrs $new, $otherPairs.length
          addPair $new

      $form.on "click", ".close", ->
        $el = $(@).closest(".association-pair")
        removePair $el
        $otherPairs.each (i) -> updateAttrs $(@), i

    play: ($form) ->

      $pairs    = $(".association-pair", $form)

      $static   = $(".association-pair-static", $pairs)
      $dynamic  = $(".association-pair-dynamic", $pairs)

      widths    = []
      limit     = $form.width() * 2/3

      swap = ($one, $two) ->
        $oneParent = $one.parent()
        $twoParent = $two.parent()

        $one.prependTo $twoParent
        $two.prependTo $oneParent

        $one.next().attr "value", $one.text()
        $two.next().attr "value", $two.text()

      $pairs.removeClass("js-hidden")

      $pairs.find("input").each ->
        $el = $("<span>").text $(@).val()
        $(@).before $el
        $(@).hide()

      $static
        .css("width", "auto")
        .each -> widths.push $(@).width()

      maxWidth = Math.max.apply(Math, widths) + 10
      maxWidth = limit if maxWidth > limit

      $static.width(maxWidth)

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
