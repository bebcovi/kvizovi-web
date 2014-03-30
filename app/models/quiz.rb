require "pg_search"

class Quiz < ActiveRecord::Base
  include PgSearch

  belongs_to :school
  has_many :questions, dependent: :destroy
  has_many :snapshots, class_name: "QuizSnapshot", counter_cache: :play_count
  has_many :played_quizzes, through: :snapshots

  mount_uploader :image, ImageUploader

  validates :name, presence: true, uniqueness: {scope: :school_id}

  scope :activated,     -> { where(activated: true) }
  scope :public,        -> { where(private: false) }
  scope :by_popularity, -> { order(play_count: :desc) }

  pg_search_scope :search,
    against: {name: "A"},
    associated_against: {
      questions: {content: "B", data: "C"}
    },
    using: {
      tsearch: {prefix: true},
      trigram: {},
    },
    ignoring: :accents

  accepts_nested_attributes_for :questions

  def to_s
    name
  end
end
