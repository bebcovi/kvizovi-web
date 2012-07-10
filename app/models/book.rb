class Book < ActiveRecord::Base
  attr_accessible :author, :title, :year
end
