#= require jquery
#= require jquery_ujs
#
#= require turbolinks
#= require jquery.turbolinks
#
#= require twitter/bootstrap/transition
#= require twitter/bootstrap/alert
#= require twitter/bootstrap/dropdown
#= require twitter/bootstrap/modal
#= require twitter/bootstrap/tooltip
#= require twitter/bootstrap/popover
#
#= require_self
#
#= require_directory .

$.fn.isEmpty = -> @.length == 0

jQuery ->
  $(".btn[title]").tooltip()
