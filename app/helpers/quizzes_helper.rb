module QuizzesHelper
  def grades(grade)
    ("#{grade}a".."#{grade}l").zip("#{grade}a".."#{grade}l")
  end
end
