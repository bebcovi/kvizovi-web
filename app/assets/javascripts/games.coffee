Lektire.Initializers.games = ->

  switch $('body').attr('class').split(' ')[1]

    when 'new'

      $form     = $('form')
      $quizzes  = $form.find '.quizzes'
      $players  = $form.find '.players'
      $login    = $form.find '.login'
      $controls = $form.find '.controls'

      $plural   = $controls.find '.plural'
      $name     = $controls.find '.name'

      $players.hide()
      $login.hide()
      $controls.hide()

      $quizzes.on 'click', ':radio', ->
        $players.show()
        $controls.show()
        $name.text $(@).next().text()

      $players.on 'click', ':radio', ->
        switch $(@).val()
          when '1'
            $login.hide()
            $login.find('input').val ''
            $plural.text ''
          when '2'
            $login.show()
            $plural.text 'te'

    when 'edit'

      # association

      conversion = (el) ->
        result = el.clone()
        result.find('input').each -> $(@).replaceWith($(@).val())
        el.after(result)
        el.hide()
        result

      $form             = $('form.association')

      $static           = {}
      $interactive      = {}

      $static.old       = $form.find('.static')
      $static.new       = conversion($static.old)

      $interactive.old  = $form.find('.interactive')
      $interactive.new  = conversion($interactive.old)

      # this function only works for these type
      # of situations, don't use it elsewhere :)

      jQuery.fn.swapWith = (to) ->
        @.each ->
          $from = $(@).parent()
          $to = $(to).parent()

          $(@).appendTo $to
          $(to).appendTo $from

      $interactive.new.find('div')
        .draggable
          addClasses: false
          revert: 'invalid'
          revertDuration: 250
          helper: 'clone'
          zIndex: 10
          start: -> $(@).addClass 'original'
          stop:  -> $(@).removeClass 'original'

        .droppable
          addClasses: false
          hoverClass: 'hover'
          drop: (e, ui) -> $(@).swapWith ui.draggable

  # score

  delay = 500

  $('#score li').each ->

    $rank     = $(@).find '.rank'
    $label    = $(@).find '.label'
    $fill     = $(@).find '.fill'

    width     = $fill.css 'width'

    update    = ->

      currentWidth = parseFloat $fill.width()
      percentage = currentWidth / $label.width() * 100

      if currentWidth
        $label.text "#{Math.round(percentage)}%"
      else
        $label.text "0%"

    $rank.hide()
    $fill.hide()

    $fill.css 'width', '0%'

    update()

    window.setTimeout ->
      $fill.show().animate
        width     : width
      ,
        duration  : 2000
        easing    : 'easeOutCubic'
        step      : update
        complete  : -> $rank.fadeIn 'fast'
    , delay

    delay += 2000
