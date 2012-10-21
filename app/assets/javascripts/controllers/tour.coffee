$ = jQuery

App.Controllers.tour = do ->

  index: ->

    $toc      = $('#toc')
    $active   = []
    highlight = ($item) ->
      $active.removeClass('active') if $active.length
      $item.addClass('active')
      $active = $item

    $toc
      .toc
        container: '#toc-content'
        highlightOffset: 50
      .on 'click', 'a', ->
        highlight $(@).parent()
