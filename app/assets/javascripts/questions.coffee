Lektire.Initializers.questions = ->
  $sections = $('form.new_question').children('.boolean, .choice, .association, .photo, .text').slice(1)

  $sections.hide()

  $('ol').on 'click', '[type=radio]', (e) ->
    i = parseInt($(@).val()) - 1
    $sections.hide()
    $sections.eq(i).show()
    console.log $sections.eq(i)
