module QuizzesHelper
  def grades
    school = current_user
    ordinalize(school.grades).zip(school.grades)
  end
end
