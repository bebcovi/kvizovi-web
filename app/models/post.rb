class Post < ActiveRecord::Base
  has_many :readings, dependent: :destroy

  validates :title, presence: true
  validates :body,  presence: true

  default_scope  ->        { order(created_at: :desc) }
  scope :not_in, ->(posts) { where.not(id: posts.pluck(:id)) }
end
