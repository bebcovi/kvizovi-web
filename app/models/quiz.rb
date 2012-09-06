# encoding: utf-8

class Quiz < ActiveRecord::Base
  belongs_to :school
  has_many :questions, dependent: :destroy
  has_many :games

  serialize :grades, Array

  scope :activated, where(activated: true)

  validate :validate

  def grades=(array)
    write_attribute(:grades, array.reject(&:blank?).map(&:to_i))
  end

  def to_s
    name
  end

  private

  def validate
    # Presence
    if name.blank?
      errors[:base] << "Ime kviza ne smije biti prazno."
    # Uniqueness
    elsif quiz = self.class.find_by_name(name)
      errors[:base] << "Već postoji kviz s tim imenom." unless quiz.id == id
    end
    # Presence
    if grades.none?(&:present?)
      errors[:base] << "Niste odabrali razred(e) za koji(e) će ovaj kviz biti namijenjen."
    end
  end
end
