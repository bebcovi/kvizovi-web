do ($ = jQuery) ->

  App.Controllers.quiz =

    choose: ->

      console.log "quiz"

      $form           = $("form")

      $sections       = $form.find("section")

      $quizzes        = $sections.filter ".quizzes"
      $players        = $sections.filter ".players"
      $login          = $sections.filter ".login"

      $buttons        = $form.find ".btn-toolbar"
      $button         = $buttons.find "button"

      $quizzesChecked = $quizzes.find ":checked"
      $playersChecked = $players.find ":checked"

      setQuizName     = (name) -> $buttons.find(".name").text(" #{name}")

      setPlural       = -> $button.html $button.html().replace(/(Započni)\b/, "$1te")
      setSingular     = -> $button.html $button.html().replace(/(Započni)\w+/, "$1")

      if $quizzesChecked.length
        $buttons.removeClass("js-hidden")
        setQuizName $quizzesChecked.closest("label").text()
        if $playersChecked.val() is "2"
          $players.removeClass("js-hidden")
          $login.removeClass("js-hidden")
          setPlural()

      $quizzes.on "click", "input:radio", ->
        $players.removeClass("js-hidden")
        setQuizName $(@).closest("label").text()

      $players.on "click", "input:radio", ->
        $buttons.removeClass("js-hidden")
        switch $(@).val()
          when "1"
            $login.addClass("js-hidden")
            setSingular()
          when "2"
            $login.removeClass("js-hidden")
            setPlural()

      $button.on "click", ->
        localStorage.removeItem("total")

    prepare: ->

      @choose()

    play: ->

      $form        = $("form")

      $buttons     = $(".btn-toolbar", $form)

      $timer       = $(".timer")
      $time        = $(".timer-time", $timer)

      updateTimer = ->
        current = moment.duration total

        min     = current.minutes()
        sec     = current.seconds()

        if sec > 9
          $time.text "#{min}:#{sec}"
        else
          $time.text "#{min}:0#{sec}"

        if min == 0
          if 5 < sec <= 10
            $timer.addClass("text-warning")
          else if sec <= 5
            $timer
              .removeClass("text-warning")
              .addClass("text-error")

      clearStorage = ->
        localStorage.removeItem "total"

      showFeedback = ->
        $.modalAjax
          type: $form.attr("method")
          url: $form.attr("action")
          data: $form.serialize()
          required: true
          onOpen: clearStorage

      timesUp = showFeedback

      if localStorage["total"]
        total = localStorage["total"] - 0
      else
        total = 1 * 60 * 1000
        localStorage["total"] = total

      countdown = do ->

        if total > 0 and localStorage["total"]
          updateTimer()

          # total -= 1000

          localStorage["total"] = total
          setTimeout arguments.callee, 1000

        else if total <= 0
          updateTimer()
          timesUp()

      $form.find(".cancel").on "click", (event) ->
        event.preventDefault()

        $quitButton     = $(@)
        quitButtonText  = $quitButton.text()

        $quitButton
          .attr("disabled", "disabled")
          .text("Pričekajte...")

        $.modalAjax
          url: @href
          onCancel: ->
            $quitButton
              .removeAttr("disabled")
              .text(quitButtonText)
          onSubmit: clearStorage

      $(".navbar").on "click", "a", (event) ->
        event.preventDefault()
        href = @href
        $.modalAjax
          url: $form.find(".cancel").attr("href")
          onSubmit: (event) ->
            event.preventDefault()
            clearStorage()
            location.href = href

      $form.on "submit", (event) ->
        event.preventDefault()
        showFeedback()
