module QuizzesHelper
  def grades(grade)
    ("#{grade}.a".."#{grade}.l").map { |label| [label, label.delete(".")] }
  end
end
