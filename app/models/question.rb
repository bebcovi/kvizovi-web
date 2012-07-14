class Question < ActiveRecord::Base
  attr_accessible :content, :kind, :answer, :points, :data
  attr_accessor :data

  serialize :content
  serialize :answer
  has_attached_file :photo, :styles => {:medium => "300x300"}

  belongs_to :quiz
  belongs_to :book

  before_create :write_answers

  def kind
    TYPES[read_attribute(:kind)]
  end

  def column(side)
    if side == :left
      content[:data].first
    else
      content[:data].last
    end
  end

  private

  def write_answers
    case kind
    when :boolean
      self.answer = data[:boolean]
    when :choice
      self.content[:data] = data[:choice]
      self.answer = data[:choice].first
    when :association
      left_column, right_column = data[:association].first(4), data[:association].last(4)
      self.content[:data] = [left_column, right_column]
      self.answer = Hash[left_column.zip(right_column)]
    when :photo
      self.photo = data[:photo][:photo]
      self.answer = data[:photo][:answer]
    when :text
      self.answer = data[:text]
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
