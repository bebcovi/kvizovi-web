#= require jquery
#= require jquery_ujs
#
#= require turbolinks
#= require jquery.turbolinks
#
#= require bootstrap/transition
#= require bootstrap/alert
#= require bootstrap/dropdown
#= require bootstrap/modal
#= require bootstrap/tooltip
#= require bootstrap/popover
#
#= require_self
#
#= require_directory .

$.fn.isEmpty = -> @.length == 0

$.extend $.fn.tooltip.Constructor.DEFAULTS,
  animation: false

jQuery ->
  $(".btn[title]").tooltip()
