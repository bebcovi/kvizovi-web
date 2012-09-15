# encoding: utf-8

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

  def delete_button(text)
    @template.delete_button text, student_path(student), confirm: "Jeste li sigurni da želite izbrisati svoj korisnički račun?"
  end
end
