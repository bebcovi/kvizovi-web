jQuery ->

  # turn off auto-complete in text inputs

  $('[type="text"], [type="url"]').attr 'autocomplete', 'off'

  # surround labels of SimpleForm boolean inputs with <li> elements

  $("label.radio").removeClass("radio").wrap("<li class='radio'>")
  $("label.checkbox").removeClass("checkbox").wrap("<li class='checkbox'>")

  # center table cells in survey forms

  $(".survey_fields_answer td").not(":first-of-type").addClass("text-center")
