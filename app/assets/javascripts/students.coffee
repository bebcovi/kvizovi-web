Lektire.Initializers.students = ->

  switch $('body').attr('class').split(' ')[1]

    when 'new'
      $school_level = $('#student_school_level')
      $grades = $('#student_grade option').eq(3).nextAll()

      $school_level.on 'change', ->
        switch $(@).val()
          when '1' then $grades.show()
          when '2' then $grades.hide()
