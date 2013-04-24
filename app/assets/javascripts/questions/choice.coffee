do ($ = jQuery) ->

  App.Questions.choice =

    design: ($form) ->

      $options      = $(".choice-option", $form)
      $firstOption  = $options.first()
      $otherOptions = $firstOption.siblings()
      $template     = $firstOption.clone()

      $addButton    = $.addButton.clone()

      updateAttrs   = ($el, i) ->

        $input = $el.find "input"

        i += 2

        id = $input.attr("id")
        placeholder = $input.attr("placeholder")

        $input.attr "id",           id.replace(/\d+/, i)
        $input.attr "placeholder",  placeholder.replace(/\d+/, i)

      addOption = ($el) ->
        $otherOptions = $otherOptions.add $el.insertBefore($addButton)

      removeOption = ($el) ->
        $otherOptions = $otherOptions.not $el.remove()

      filled = ($el) ->
        result = true
        $el.find("input").each -> result = result and !!$(@).val()
        result

      $otherOptions.add($template)
        .append $.removeButton
          .clone()
          .addClass("close")
          .attr("tabindex", -1)

      $template
        .find("input").val("").end()
        .find(".success").removeClass("success").end()
        .find(".help-block, .error-block, .additional-info").remove()

      if $otherOptions.length
        $addButton.insertAfter($otherOptions.last())
      else
        $addButton.insertAfter($firstOption)

      $addButton.on "click", (event) ->
        $new = $template.clone()
        event.preventDefault()
        updateAttrs $new, $otherOptions.length
        addOption $new

      $form.on "click", ".close", ->
        $el = $(@).closest(".choice-option")
        removeOption $el
        $otherOptions.each (i) -> updateAttrs $(@), i
