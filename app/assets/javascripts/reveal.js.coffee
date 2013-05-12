do ($ = jQuery) ->

  $content  = $(".reveal-content")

  if $content.length

    text        = $content.attr("data-reveal")
    $toggleBtn  = $("<a>", href: "#", class: "reveal-toggle is-hidden", title: text, "data-placement": "right")

    $content.each ->
      $this = $(@)
      $btn = $toggleBtn.clone()

      $btn
        .appendTo($this.prev())
        .on "click", do ($this, $btn) ->
          (event) ->
            event.preventDefault()
            $btn.toggleClass("is-hidden")
            $this.toggleClass("is-hidden")

    $(".reveal-toggle").tooltip
      animation: false
      placement: "bottom"
      container: "body"
