Lektire.Initializers.games = ->

  switch $('body').attr('class').split(' ')[1]

    when 'new'

      $form     = $('form')
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
          when '1'
            $login.hide()
            $login.find('input').val('')
          when '2' then $login.show()

    when 'edit'

      $progress = $('#progress')
      $bar = $('<div class="bar">')
      $div = $('<div>').appendTo $bar
      status = (parseInt(i) for i in $progress.text().split('/'))

      $div.css 'width', "#{status[0]/status[1] * 100}%"

      $progress.text('')
      $progress.append $bar

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

      $interactive.new.sortable
        placeholder: 'placeholder'
        forcePlaceholderSize: true
        tolerance: 'pointer'
        update: ->
          $old = $interactive.old.find 'input'
          $new = $interactive.new.find 'li'

          $old.each (i) -> $(@).val $new.eq(i).text()
