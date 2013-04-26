class QuizRunner
  def initialize(store)
    @store = store
  end

  def prepare!(hash)
    @store[:quiz_id]          = hash[:quiz_id]
    @store[:question_ids]     = hash[:question_ids].join(",")
    @store[:question_answers] = hash[:question_ids].count.times.map{"nil"}.join(",")
    @store[:student_ids]      = hash[:student_ids].join(",")

    @store[:current_student]  = 0
    @store[:current_question] = 0

    @store[:begin] = Time.now.to_i

    self
  end

  def save_answer!(answer)
    answers = @store[:question_answers].split(",")
    answers[Integer(@store[:current_question])] = answer.to_s
    @store[:question_answers] = answers.join(",")
  end

  def next_question!
    next_student!
    @store[:current_question] = Integer(@store[:current_question]) + 1
  end

  def next_student!
    @store[:current_student] =
      (Integer(@store[:current_student]) + 1) %
      @store[:student_ids].split(",").count
  end

  def finish!
    @store[:end] = Time.now.to_i
  end
end
