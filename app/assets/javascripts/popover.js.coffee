do ($ = jQuery) ->

  $("input[type=\"text\"][data-content]").popover
    html: true
    trigger: "focus"

  $("button[data-content]").popover
    animation: false
    html: true
    trigger: "hover"
