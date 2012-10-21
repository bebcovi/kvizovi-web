$ = jQuery

App.Controllers.tour = do ->

  index: ->

    $toc     = $('<ul>').appendTo $('#toc')
    $active  = []

    highlight = ($item) ->
      $active.removeClass('active') if $active.length
      $item.addClass('active')
      $active = $item

    $('#toc-content').find('h1, h2, h3').each (i) ->
      $li = $('<li>').addClass("toc-#{@.tagName.toLowerCase()}")
      $a  = $('<a>')
        .attr('href', "#toc#{i}")
        .text($(@).text())
      $toc.append $li.append($a)
      $(@).attr 'id', "toc#{i}"

    $toc.on 'click', 'a', (event) ->
      event.preventDefault()
      highlight $(@).parent()
      $('html, body').animate {scrollTop: $(@hash).offset().top}, 250
