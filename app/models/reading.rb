class Reading < ActiveRecord::Base
  belongs_to :post
  belongs_to :user, polymorphic: true

  validates_uniqueness_of :post_id, scope: [:user_id, :user_type]
end
