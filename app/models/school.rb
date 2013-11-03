require "squeel"

class School < ActiveRecord::Base
  has_many :students,  dependent: :destroy
  has_many :quizzes,   dependent: :destroy
  has_many :questions
  has_many :played_quizzes, through: :quizzes
  has_many :readings, as: :user, dependent: :destroy
  has_many :read_posts, through: :readings, source: :post

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :place,    presence: true
  validates :region,   presence: true
  validates :level,    presence: true
  validates :key,      presence: true

  after_create :create_example_quizzes

  def type; "school"; end

  def to_s; name; end

  def last_activity
    LastActivity.for(self).read
  end

  def unread_posts
    Post.not_in(read_posts)
  end

  private

  def create_example_quizzes
    ExampleQuizzesCreator.new(self).create
  end
end
