class StudentPresenter < BasePresenter
  presents :student

  def full_name
    student.full_name
  end

  def username
    student.username
  end

  def grade
    ordinalize(student.grade)
  end
end
