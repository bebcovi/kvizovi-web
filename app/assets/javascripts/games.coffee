Lektire.Initializers.games = ->
  $form = $('#new_submitted_game')
  $quizzes  = $form.find '.quizzes'
  $players  = $form.find '.players'
  $login    = $form.find '.login'
  $controls = $form.find '.controls'

  $players.hide()
  $login.hide()
  $controls.hide()

  $quizzes.one 'click', ':radio', ->
    $players.show()
    $controls.show()

  $players.on 'click', ':radio', ->
    switch $(@).val()
      when '1' then $login.hide()
      when '2' then $login.show()
