class Region < ActiveRecord::Base
  has_many :schools

  default_scope order(:name)

  validates_uniqueness_of :name

  def to_s
    name
  end
end
