#= require jquery
#= require jquery_ujs
#
#= require turbolinks
#= require jquery.turbolinks
#
#= require bootstrap/alert
#= require bootstrap/dropdown
#= require bootstrap/tooltip
#
#= require_self
#
#= require_directory .

$.icon = (name) -> "<i class=\"icon-#{name}\"></i>"

$.extend $.fn.tooltip.Constructor.DEFAULTS,
  animation: false

jQuery ->
  $(".btn[title]").not('.btn-group .btn').tooltip()

  $(".btn-group .btn[title]").tooltip
    container: "body"

  $("[data-toggle=tooltip").tooltip
    animation: true

@App = {}
