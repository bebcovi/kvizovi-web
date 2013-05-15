do ($ = jQuery) ->

  # turn off auto-complete in text inputs

  $('[type="text"], [type="url"]').attr 'autocomplete', 'off'

  # remove the .btn class

  $('.alert-info').find('.close').removeClass('btn')

  # center table cells in survey forms

  $form = $(".new_survey")

  if $form.length

    $table = $form.find(".survey_fields_answer").find("table")

    $table.find("td").not(":first-of-type").addClass("text-center")
