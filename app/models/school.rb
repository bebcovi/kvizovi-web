# encoding: utf-8
require_relative "../../lib/has_many_questions"
require "securerandom"

class School < ActiveRecord::Base
  has_many :students, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  extend HasManyQuestions
  has_many_questions dependent: :destroy

  has_secure_password

  validates_presence_of :name, :level, :username, :key, :place, :region, :email
  validates_presence_of :password, on: :create
  validates_uniqueness_of :username, :email

  def to_s
    name
  end

  def reset_password
    new_password = SecureRandom.hex(5)
    update_attributes(password: new_password)
    new_password
  end

  def grades
    primary? ? (1..8) : (1..4)
  end

  def primary?
    level == "Osnovna"
  end

  def secondary?
    level == "Srednja"
  end

  def self.authenticate(credentials)
    find_by_username(credentials[:username]).try(:authenticate, credentials[:password])
  end
end

require "rack/test/uploaded_file"

class School < ActiveRecord::Base
  def create_example_quizzes
    quiz = quizzes.create!([
      {name: "Antigona"}
    ]).first

    quiz.boolean_questions.create!([
      {
        content: %("Antigona" je komedija.),
        answer: false
      }
    ])

    quiz.choice_questions.create!([
      {
        content: %(Kako se zove Antigonin zaručnik?),
        provided_answers: [
          "Hemon",
          "Edip",
          "Eteoklo",
          "Kreont"
        ]
      }
    ])

    quiz.association_questions.create!([
      {
        content: %(Uz likove iz "Antigone" pridruži odgovarajuće opise:),
        associations: {
          "Kreont"    => "Tebanski kralj",
          "Tiresija"  => "Prorok",
          "Hemon"     => "Antigonin zaručnik"
        }
      }
    ])

    quiz.image_questions.create!([
      {
        content: %(Koji je ovo lik iz "Antigone"?),
        image_file: Rack::Test::UploadedFile.new("#{Rails.root}/db/seeds/files/antigona.jpg", "image/jpeg"),
        answer: "Antigona"
      }
    ])

    quiz.text_questions.create!([
      {
        content: %(Tko je Antigonin i Izmenin otac?),
        answer: "Edip"
      }
    ])

    quiz.questions.update_all(school_id: id)
  end
end
