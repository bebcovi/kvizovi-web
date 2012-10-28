$ = jQuery

App.Controllers.tour =

  index: ->

    $toc     = $('<ul>').addClass('toc')
    $content = $('.content')
    $active  = []

    highlight = ($item) ->
      $active.removeClass('active') if $active.length
      $item.addClass('active')
      $active = $item

    $content
      .removeClass('content')
      .addClass('toc_content')
      .find('h2, h3').each (i) ->
        $li = $('<li>').addClass("toc_#{@.tagName.toLowerCase()}")
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

    # make the question type list unstyled

    $('ul').each ->
      if $(@).find('i').length > 3
        $(@).addClass 'question_types'
