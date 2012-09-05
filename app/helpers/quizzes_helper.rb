module QuizzesHelper
  def grades
    ordinalize(current_school.grades).zip(current_school.grades)
  end
end
