require "factory_girl"

FactoryGirl.factories.clear
FactoryGirl.define do
  factory :school, traits: [:password]
  factory :student, traits: [:password]

  factory :quiz

  factory :boolean_question, aliases: [:question]
  factory :choice_question
  factory :association_question
  factory :image_question
  factory :text_question

  factory :played_quiz
  factory :quiz_snapshot

  factory :post

  trait(:with_school) { school }
  trait(:with_quiz)   { quiz }
  trait(:password)    { password_digest "foo" }
end
