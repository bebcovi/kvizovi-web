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

  def rank
    points = case student.score % 10
             when 1      then "bod"
             when (2..4) then "boda"
             else             "bodova"
             end
    rank = case student.score
           when (0..50)   then "znalac malac"
           when (50..100) then "ekspert"
           else                "super ekspert"
           end

    raw("#{icon("trophy", class: RANKS[rank])} #{rank} (#{student.score} #{points})")
  end

  RANKS = {
    "znalac malac"  => "bronze",
    "ekspert"       => "silver",
    "super ekspert" => "gold"
  }
end
