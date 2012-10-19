require_relative "../question"
require_relative "data/association_question_data"

class AssociationQuestion < Question
  delegate :associations, to: :data

  def answer
    associations.original
  end

  def correct_answer?(value)
    answer == convert_to_hash(value)
  end

  def points
    4
  end

  def randomize!
    data.randomize!
    super
  end

  private

  def convert_to_hash(value)
    value.flatten == value ? Hash[*value] : Hash[value]
  end
end
