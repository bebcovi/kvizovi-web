class QuizState
  def initialize(store)
    @store = store
  end

  def questions_count
    question_ids.count
  end

  def current_question
    question(Integer(@store[:current_question]))
  end

  def questions
    questions_count.times.map { |i| question(i) }
  end

  def students_count
    student_ids.count
  end

  def students
    students_count.times.map { |i| student(i) }
  end

  def current_student
    student(Integer(@store[:current_student]))
  end

  def quiz
    {id: Integer(@store[:quiz_id])}
  end

  def begin_time
    Time.at(Integer(@store[:begin]))
  end

  def end_time
    Time.at(Integer(@store[:end]))
  end

  def finished?
    questions.last[:answer] != nil
  end

  def to_h
    {
      students:  students,
      quiz:      quiz,
      questions: questions,
      begin:     begin_time,
      end:       end_time,
    }
  end

  private

  def question_ids
    @store[:question_ids].split(",").map do |id|
      Integer(id)
    end
  end

  def question_answers
    @store[:question_answers].split(",").map do |answer|
      {"true" => true, "false" => false, "nil" => nil}[answer]
    end
  end

  def question(i)
    {number: i + 1, id: question_ids[i], answer: question_answers[i]}
  end

  def student_ids
    @store[:student_ids].split(",").map do |id|
      Integer(id)
    end
  end

  def student(i)
    {number: i + 1, id: student_ids[i]}
  end
end
