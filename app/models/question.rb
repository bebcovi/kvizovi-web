class Question < ActiveRecord::Base
  attr_accessible :content, :correct_answer, :points, :kind

  # Virtual attributes
  attr_accessor :boolean, :choice, :association, :photo, :text
  attr_accessible :boolean, :choice, :association, :photo, :text
  serialize :correct_answer
  serialize :answers

  belongs_to :quiz
  belongs_to :book

  before_create :write_answers

  def kind
    TYPES[read_attribute(:kind)]
  end

  private

  def write_answers
    case kind
    when :boolean
      self.correct_answer = boolean
    when :choice
      self.correct_answer = choice.first
      self.answers = choice
    when :association
      self.correct_answer = Hash[association[:left_column].zip(association[:right_column])]
      self.answers = [association[:left_column], association[:right_column]]
    end
  end

  TYPES = {
    1 => :boolean,
    2 => :choice,
    3 => :association,
    4 => :photo,
    5 => :text
  }
end
