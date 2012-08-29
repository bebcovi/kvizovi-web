Lektire.Initializers.questions = ->

  switch $('body').attr('class').split(' ')[1]

    when 'new'
      $sections = $('form').children('#boolean, #choice, #association, #photo, #text')

      $sections.hide()

      $('ol').on 'click', '[type=radio]', (e) ->
        i = parseInt($(@).val()) - 1
        $sections.hide()
        $sections.find('[type=text]').val('')
        $sections.eq(i).show()
        console.log $sections.eq(i)
