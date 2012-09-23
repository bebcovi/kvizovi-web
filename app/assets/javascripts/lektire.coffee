jQuery ($) ->

  # initializers

  $body       = $('body')
  $form       = $('form')

  bodyClass   = $body.attr('class') || ''
  formClass   = $form.attr('class') || ''

  list              = (controller for controller of App.controllers)
  regex             = RegExp list.join('|')
  controllerResult  = bodyClass.match(regex) || []

  list              = (question for question of App.questions)
  regex             = RegExp list.join('|')
  questionResult    = formClass.match(regex) || []

  App.general.init()
  App.helper.init()

  if controllerResult?
    App.controllers[item].init(bodyClass) for item in controllerResult

  if questionResult?
    App.questions[item].init($form, formClass) for item in questionResult
