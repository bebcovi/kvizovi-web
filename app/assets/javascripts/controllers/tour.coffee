$ = jQuery

App.Controllers.tour = do ->

  index: ->

    $toc     = $('<ul>').addClass('toc')
    $content = $('.content')
    $active  = []

    highlight = ($item) ->
      $active.removeClass('active') if $active.length
      $item.addClass('active')
      $active = $item

    $content
      .attr('class', 'toc-content')
      .find('h1, h2, h3').each (i) ->
        $li = $('<li>').addClass("toc-#{@.tagName.toLowerCase()}")
        $a  = $('<a>')
          .attr('href', "#toc#{i}")
          .text($(@).text())
        $toc.append $li.append($a)
        $(@).attr 'id', "toc#{i}"

    $content.before $toc

    $toc.on 'click', 'a', (event) ->
      event.preventDefault()
      highlight $(@).parent()
      $('html, body').animate {scrollTop: $(@hash).offset().top}, 250
