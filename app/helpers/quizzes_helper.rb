module QuizzesHelper
  def grades
    school = current_user
    school.grades.map { |n| "#{n}." }.zip(school.grades)
  end
end
