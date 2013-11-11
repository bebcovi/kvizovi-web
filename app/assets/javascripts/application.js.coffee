#= require jquery
#= require jquery_ujs
#
#= require turbolinks
#= require jquery.turbolinks
#
#= require twitter/bootstrap
#
#= require_self
#
#= require_directory .

$.fn.isEmpty = -> @.length == 0

jQuery ->
  $(".btn[title]").tooltip()
