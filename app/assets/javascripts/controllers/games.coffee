$ = jQuery

App.Controllers.games = do ->

  new: ->

    $form           = $('form')

    $sections       = $form.find('section')

    $quizzes        = $sections.filter '.quizzes'
    $players        = $sections.filter '.players'
    $login          = $sections.filter '.login'

    $buttons        = $form.find '.buttons'
    $button         = $buttons.find 'button'

    $quizzesChecked = $quizzes.find ':checked'
    $playersChecked = $players.find ':checked'

    setQuizName     = (name) -> $buttons.find('.name').text(" #{name}")

    setPlural       = -> $button.html $button.html().replace(/(Započni)\b/, '$1te')
    setSingular     = -> $button.html $button.html().replace(/(Započni)\w+/, '$1')

    if not $quizzesChecked.length
      $players.hide()
      $login.hide()
      $buttons.hide()
    else
      setQuizName $quizzesChecked.next().text()
      setPlural() if $playersChecked.val() is '2'

    $quizzes.on 'click', ':radio', ->
      $players.show()
      setQuizName $(@).next().text()

    $players.on 'click', ':radio', ->
      $buttons.show()
      switch $(@).val()
        when '1'
          $login.hide()
          setSingular()
        when '2'
          $login.show()
          setPlural()

  create: ($form) ->

    @new()

  edit: ->

    $form        = $('form')

    $buttons     = $('.buttons', $form)

    $timer       = $.timer.clone().appendTo $('#main')
    $time        = $('.time', $timer)

    clearStorage = -> localStorage.removeItem 'total'

    if localStorage['total']
      total = localStorage['total'] - 0
    else
      total = 2 * 60 * 1000
      localStorage['total'] = total

    countdown = do ->

      current = moment.duration total

      min = current.minutes()
      sec = current.seconds()

      if sec > 9
        $time.text "#{min}:#{sec}"
      else
        $time.text "#{min}:0#{sec}"

      if total
        localStorage['total'] = total
        total -= 1000
        setTimeout arguments.callee, 1000
      else
        clearStorage()
        alert "Isteklo je vrijeme! Što god da si obilježio vrijedi se."
        $('form').submit()

    $buttons.children().on 'click', clearStorage

  show: ->

    delay = 500

    $('.score li').each ->

      $rank  = $(@).find '.rank'
      $label = $(@).find '.label'
      $fill  = $(@).find '.fill'

      width  = $fill.css 'width'

      update = ->

        currentWidth = parseFloat $fill.width()
        percentage = currentWidth / $label.width() * 100

        if currentWidth then $label.text "#{Math.round(percentage)}%" else $label.text "0%"

      $rank.hide()
      $fill.hide()

      $fill.css 'width', '0%'

      update()

      if width?
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
      else
        window.setTimeout ->
          $rank.fadeIn 'fast'
        , delay
