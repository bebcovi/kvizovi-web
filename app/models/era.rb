class Era < ActiveRecord::Base
  has_many :books
  belongs_to :school

  def to_s
    name
  end
end
