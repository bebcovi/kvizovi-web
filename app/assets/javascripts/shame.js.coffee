jQuery ->

  # turn off auto-complete in text inputs

  $('[type="text"], [type="url"]').attr 'autocomplete', 'off'

  # surround labels of SimpleForm boolean inputs with <li> elements

  $("ul label.radio").removeAttr("class").wrap("<li class='radio'>")
  $("ul label.checkbox").removeAttr("class").wrap("<li class='checkbox'>")

  # center table cells in survey forms

  $(".survey_fields_answer td").not(":first-of-type").addClass("text-center")
