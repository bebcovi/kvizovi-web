jQuery ($) ->

  $body      = $('body')
  $form      = $('form')

  bodyClass  = $body.attr 'class'
  formClass  = $form.attr 'class'

  cAction    = try bodyClass.match(/index|new|create|edit|show/).join('')
  qAction    = try formClass.match(/new|edit|show/).join('')

  list       = (controller for controller of App.Controllers)
  regex      = RegExp list.join('|')
  cId        = try bodyClass.match(regex).join('')

  list       = (question for question of App.Questions)
  regex      = RegExp list.join('|')
  qId        = try formClass.match(regex).join('')

  App.helper()
  App.general()

  try App.Controllers[cId][cAction]()
  try App.Questions[qId][qAction]($form)
