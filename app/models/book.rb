# encoding: utf-8

class Book < ActiveRecord::Base
  belongs_to :school
  belongs_to :era

  def to_s
    "#{author} – #{title}"
  end
end
