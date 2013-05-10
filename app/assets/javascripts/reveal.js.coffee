do ($ = jQuery) ->

  attr      = "data-reveal"
  $content  = $("[#{attr}]")

  if $content.length

    text        = $content.attr(attr)
    $toggleBtn  = $("<a>", href: "#", text: text, class: "reveal-toggle space-half-top")

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
              .removeClass("js-hidden")
              .hide()
              .fadeIn("fast")
