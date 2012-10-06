jQuery ($) ->

  $body            = $('body')
  $form            = $('form')

  bodyClass        = $body.attr 'class'
  formClass        = $form.attr 'class'

  controllerAction = try bodyClass.match(/new|create|edit|show/).join ''
  questionAction   = try formClass.match(/new|edit|show/).join ''

  list             = (controller for controller of App.Controllers)
  regex            = RegExp list.join('|')
  controllerId     = try bodyClass.match(regex).join ''

  list             = (question for question of App.Questions)
  regex            = RegExp list.join('|')
  questionId       = try formClass.match(regex).join ''

  App.helper()
  App.general()

  try App.Controllers[controllerId][controllerAction]()
  try App.Questions[questionId][questionAction]($form)
