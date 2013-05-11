do ($ = jQuery) ->

  $.icon = (name) -> "<i class=\"icon-#{name}\"></i>"

  String.prototype.prependIcon  = (name) -> "#{$.icon(name)} #{@}"
  String.prototype.appendIcon   = (name) -> "#{@} #{$.icon(name)}"
