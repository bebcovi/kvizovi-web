#= require jquery
#= require jquery_ujs
#
#= require jquery.ui.droppable
#
#= require turbolinks
#= require jquery.turbolinks
#
#= require twitter/bootstrap
#
#= require moment
#= require_self
#
#= require ./add_or_remove_options
#= require ./additional-info
#= require ./image_upload
#= require ./shame
#= require ./sorting
#= require ./reveal

$.fn.isEmpty = -> @.length == 0

jQuery ->
  $(".btn[title]").tooltip()
