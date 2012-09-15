$ ->

  # initializers

  $body       = $('body')
  $form       = $('form')

  bodyClass   = $body.attr('class') || ''
  formClass   = $form.attr('class') || ''

  list              = (controller for controller of Lektire.Controllers)
  regex             = RegExp list.join('|')
  controllerResult  = bodyClass.match(regex) || []

  list              = (question for question of Lektire.Questions)
  regex             = RegExp list.join('|')
  questionResult    = formClass.match(regex) || []

  Lektire.general()
  Lektire.helper()

  if controllerResult?
    Lektire.Controllers[item](bodyClass) for item in controllerResult

  if questionResult?
    Lektire.Questions[item]($form, formClass) for item in questionResult
