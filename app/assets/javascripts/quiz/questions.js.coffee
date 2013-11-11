#= require jquery.ui.droppable

jQuery ->

  unless $(".timer").isEmpty()
    new AssociationQuestion("table").enhance()

class @AssociationQuestion

  constructor: (container) ->
    @container = $(container)
    @pairs     = $(".association-pair")
    @static    = $(".association-pair-static")
    @dynamic   = $(".association-pair-dynamic")

  enhance: ->
    @pairs.find("input")
      .before(-> $("<span>").text $(@).val())
      .hide()

    @dynamic.find("span")
      .addClass("is-unselectable")
      .draggable(@draggableOptions())
      .droppable(@droppableOptions())

  swap: ($one, $two) =>
    $oneParent = $one.parent()
    $twoParent = $two.parent()

    $one.prependTo $twoParent
    $two.prependTo $oneParent

    $one.next().val $one.text()
    $two.next().val $two.text()

  draggableOptions: ->
    addClasses:     false
    revert:         "invalid"
    revertDuration: 250
    helper:         "clone"
    zIndex:         10
    start: -> $(@).addClass "association-pair-original"
    stop:  -> $(@).removeClass "association-pair-original"

  droppableOptions: ->
    addClasses: false
    hoverClass: "association-pair-hover"
    drop: (event, ui) => @swap($(event.target), ui.draggable)
