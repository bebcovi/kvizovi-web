class Reading < ActiveRecord::Base
  belongs_to :post
  belongs_to :user, polymorphic: true

  validate :validate_uniqueness

  private

  def validate_uniqueness
    if self.class.where{(post_id == my{post_id}) &
                        (user_id == my{user_id}) &
                        (user_type == my{user_type})}.any?

      errors.add(:base, :taken)
    end
  end
end
