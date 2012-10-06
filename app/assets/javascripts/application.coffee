require ['jquery', 'extensions', 'helper', 'general', 'controllers', 'questions'], ($, extensions, helper, general, controllers, questions) ->

  $ ->

    $body            = $('body')
    $form            = $('form')

    bodyClass        = $body.attr('class') or ''
    formClass        = $form.attr('class') or ''

    controllerAction = try bodyClass.match(/new|create|edit|show/).join ''
    questionAction   = try formClass.match(/new|edit|show/).join ''

    list             = (controller for controller of controllers)
    regex            = RegExp list.join('|')
    controllerId     = try bodyClass.match(regex).join ''

    list             = (question for question of questions)
    regex            = RegExp list.join('|')
    questionId       = try formClass.match(regex).join ''

    extensions()
    helper()
    general()

    try controllers[controllerId]()[controllerAction]()
    try questions[questionId]()[questionAction]($form)
