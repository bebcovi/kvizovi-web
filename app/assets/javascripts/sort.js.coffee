do ($ = jQuery) ->

  $container = $(".sort")

  if $container.length

    $container.each ->
      $this = $(@)

      $this
        .sortable
          opacity: 0.75
          placeholder: "sort-placeholder"
          update: (event, ui) ->
            ui.item.parent().children().each (i) ->
              $(@).find("input[type=text]").val(i + 1)

        .disableSelection()
