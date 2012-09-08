Lektire.Initializers.games = ->

  switch $('body').attr('class').split(' ')[1]

    when 'new'

      $form     = $('form')
      $quizzes  = $form.find '.quizzes'
      $players  = $form.find '.players'
      $login    = $form.find '.login'
      $buttons  = $form.find '.buttons'

      $plural   = $buttons.find '.plural'
      $name     = $buttons.find '.name'

      $players.hide()
      $login.hide()
      $buttons.hide()

      $quizzes.on 'click', ':radio', ->
        $players.show()
        $name.text $(@).next().text()

      $players.on 'click', ':radio', ->
        $buttons.show()
        switch $(@).val()
          when '1'
            $login.hide()
            $plural.text ''
          when '2'
            $login.show()
            $plural.text 'te'

    when 'show'

      # score

      delay = 500

      $('.score li').each ->

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
