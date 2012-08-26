window.Lektire =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Initializers: {}
  init: ->
    switch $('body').attr('class').split(' ')[0]
      when 'students' then Lektire.Initializers.students()
      when 'games' then Lektire.Initializers.games()
      when 'questions' then Lektire.Initializers.questions()

$(document).ready ->
  Lektire.init()
