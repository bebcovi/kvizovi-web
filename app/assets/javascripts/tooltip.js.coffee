do ($ = jQuery) ->

  $("a, input[type=\"submit\"], button").filter("[title]").not("[data-content]").tooltip
    animation: false
    placement: "top"
    container: "body"

  $(".additional-info").tooltip
    animation: false
    placement: "right"
    container: "body"
