$ = jQuery

# icons

$.icon = (name) -> "<i class='icon-#{name}'></i>"

String.prototype.prependIcon  = (name) -> "#{$.icon(name)} #{@}"
String.prototype.appendIcon   = (name) -> "#{@} #{$.icon(name)}"

# properties

$.removeButton = $ '<button>',
  text: '×'
  type: 'button'

$.addButton = $ '<a>',
  html: 'Dodaj'.prependIcon('plus')
  class: 'add'
  href: '#'

$.timer = $ '<div>',
  html: $.icon('stopwatch')
  class: 'timer'
.append(' ')
.append $('<span>', {class: 'time'})

$.spinnerOptions =
  lines: 13
  length: 11
  width: 3
  radius: 11
  corners: 1
  color: 'rgba(0,0,0,0.6)'
  trail: 66
  className: 'spinner'
  top: 212

# functions

$.modalAjax = (options = {}) ->
  $('body').spin($.spinnerOptions)

  $.ajax
    type: options['type'] or 'GET'
    url: options['url']
    data: options['data'] or ''
    dataType: 'html'
    headers: {'X-noLayout': true}

    success: (data) ->
      $data         = $(data)

      $removeButton = $.removeButton
        .clone()
        .addClass('close')
        .attr('data-dismiss', 'modal')

      $dataHeader   = $data.filter('h1')
      $dataFooter   = $data.filter('form')
      $dataBody     = $data.not('h1, form')

      $modal        = $('<div>').addClass('modal')

      # loader

      $('body').spin(false)

      # modifications

      $dataFooter.find('.cancel')
        .removeClass('cancel')
        .attr('data-dismiss', 'modal')

      # component insertion

      $modalHeader = $('<div>')
        .addClass('modal-header')
        .append($removeButton)
        .append($dataHeader)

      $modalBody = $('<div>')
        .addClass('modal-body')
        .append($dataBody)

      $modalFooter = $('<div>')
        .addClass('modal-footer')
        .append($dataFooter)

      # modal insertion

      $modal.append($modalHeader)
      $modal.append($modalBody)   if $dataBody.length
      $modal.append($modalFooter) if $dataFooter.length

      $modal.modal()

      # required

      if options['required']
        $removeButton.remove()
        $modal.on 'hide', -> return false

      # callbacks

      $modal.on 'hidden', ->
        $modal.remove()

      if options['onOpen']
        options['onOpen']()

      if options['onCancel']
        $modal.on 'hidden', ->
          options['onCancel']()

      if options['onSubmit']
        $modalFooter.find('.btn-primary')
          .on 'click', options['onSubmit']

    error: -> location.href options['url']

$.getContent = (title, body) ->
  $title    = $('<h1>').text(title)
  $body     = $('<p>').text(body)

  $content  = $()

  $content.after($title)  if title
  $content.after($body)   if body

  $content

$.generateButtons = (labels) ->
  $result = $('<div>').addClass('form_controls')

  if labels['close']
    $close = $('<a>', href: '#').text(labels['close'])
    $result.append($close)

  if labels['submit']
    $submit = $('<button>', type: 'button').text(labels['submit'])
    $result.append($submit)

  $result

# globals

window.App =
  Controllers: {}
  Questions: {}
