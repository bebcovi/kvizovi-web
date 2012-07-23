class Book < ActiveRecord::Base
  attr_accessible :author, :title, :year

  validates_presence_of :author, :title, :year
end
