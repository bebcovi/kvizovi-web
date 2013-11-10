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
#
#= require ./add_or_remove_options
#= require ./additional-info
#= require ./image_upload
#= require ./shame
#= require ./sorting

jQuery ->
  $(".btn[title]").tooltip()
