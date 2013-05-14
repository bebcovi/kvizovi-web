class Survey < ActiveRecord::Base
  belongs_to :user, polymorphic: true
  has_many :fields, class_name: "SurveyField", dependent: :destroy

  accepts_nested_attributes_for :fields
end
