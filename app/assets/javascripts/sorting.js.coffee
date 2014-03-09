#= require jquery.ui.sortable

jQuery ->

  $(".sort").each ->

    $(@)
      .sortable
        opacity: 0.75
        placeholder: "sort-placeholder"
        update: (event, ui) ->
          ui.item.parent().children().each (i) ->
            $(@).find("input[type='number']").val(i + 1)
      .disableSelection()

    $(@).find("input[type='number']").hide()
