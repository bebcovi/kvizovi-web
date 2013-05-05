do ($ = jQuery) ->

  $.removeButton = $ "<button>",
    html: $.icon("cancel-circle")
    type: "button"

  $.closeButton = $ "<button>",
    html: $.icon("close")
    type: "button"

  $.addButton = $ "<a>",
    html: "Dodaj".prependIcon("plus")
    class: "add"
    href: "#"
