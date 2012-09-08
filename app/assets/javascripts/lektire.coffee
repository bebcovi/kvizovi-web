window.Lektire =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Initializers: {}
  init: ->
    Lektire.Initializers.general()
    Lektire.Initializers.helper()
    Lektire.Initializers.questionTypes()

    switch $('body').attr('class').split(' ')[0]
      when 'games'      then Lektire.Initializers.games()

jQuery -> Lektire.init()
