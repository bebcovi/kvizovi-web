class StudentPresenter < BasePresenter
  presents :student

  def school_name
    student.school.name
  end

  def grade
    ordinalize(student.grade)
  end

  def edit_button(text)
    @template.edit_button text, edit_student_path(student)
  end
end
