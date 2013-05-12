do ($ = jQuery) ->

  attr      = "data-reveal"
  $content  = $("[#{attr}]")

  if $content.length

    text        = $content.attr(attr)
    $toggleBtn  = $("<a>", href: "#", text: text, class: "reveal-toggle btn btn-mini")

    $content.each ->
      $this = $(@)
      $btn = $toggleBtn.clone()

      $btn
        .insertBefore($this)
        .on "click", do ($this, $btn) ->
          (event) ->
            event.preventDefault()
            $btn.hide()
            $this
              .removeClass("is-hidden")
              .hide()
              .fadeIn("fast")
