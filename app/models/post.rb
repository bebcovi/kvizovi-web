require "squeel"
require "acts_as_list"

class Post < ActiveRecord::Base
  acts_as_list

  has_many :readings, dependent: :destroy

  validates :title, presence: true
  validates :body,  presence: true

  default_scope  ->        { order{position.desc} }
  scope :not_in, ->(posts) { where{id.not_in(posts.select{id})} }
end
