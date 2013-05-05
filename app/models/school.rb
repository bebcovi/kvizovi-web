require "squeel"

class School < ActiveRecord::Base
  LEVELS = ["Osnovna", "Srednja"]
  REGIONS = [
    "Bjelovarsko-bilogorska županija",
    "Brodsko-posavska županija",
    "Dubrovačko-neretvanska županija",
    "Grad Zagreb",
    "Istarska županija",
    "Karlovačka županija",
    "Koprivničko-križevačka županija",
    "Krapinsko-zagorska županija",
    "Ličko-@senjska županija",
    "Međimurska županija",
    "Osječko-baranjska županija",
    "Požeško-slavonska županija",
    "Primorsko-goranska županija",
    "Sisačko-moslavačka županija",
    "Splitsko-dalmatinska županija",
    "Šibensko-kninska županija",
    "Varaždinska županija",
    "Virovitičko-podravska županija",
    "Vukovarsko-srijemska županija",
    "Zagrebačka županija",
    "Zadarska županija",
  ]

  has_many :students,  dependent: :destroy
  has_many :quizzes,   dependent: :destroy
  has_many :questions

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :email,    presence: true, uniqueness: true
  validates :place,    presence: true
  validates :region,   presence: true, inclusion: {in: REGIONS, allow_blank: true}
  validates :level,    presence: true, inclusion: {in: LEVELS, allow_blank: true}
  validates :key,      presence: true

  def type; "school"; end

  def to_s; name; end

  def primary?;   level == "Osnovna"; end
  def secondary?; level == "Srednja"; end

  def last_activity
    LastActivity.for(self)
  end
end
