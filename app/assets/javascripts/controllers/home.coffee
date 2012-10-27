$ = jQuery

App.Controllers.home = do ->

  index: ->

    $('.app_role').find('a').fancybox
      wrapCSS: 'long'
      type: 'ajax'
      live: false
      afterShow: ->
        @inner.css 'overflow', 'visible'
        $('[type="text"]').attr 'autocomplete', 'off'
