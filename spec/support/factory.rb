require "factory_girl"

module FactoryGirl
  module Strategy
    class CreateWithoutValidation < Create
      def result(evaluation)
        evaluation.object.instance_eval do
          def valid?(*args)
            super
            true
          end
        end

        super
      end
    end
  end

  register_strategy :create, Strategy::CreateWithoutValidation
end

FactoryGirl.factories.clear
FactoryGirl.define do
  factory :school, aliases: [:user]

  factory :student

  factory :quiz do
    trait :activated do
      activated true
    end
  end

  factory :boolean_question, aliases: [:question]
  factory :choice_question
  factory :association_question
  factory :image_question
  factory :text_question

  factory :played_quiz
  factory :quiz_snapshot

  factory :post

  trait :with_school do
    school
  end

  trait :with_quiz do
    school
  end

  trait :admin do
    admin true
  end
end

Factory = FactoryGirl unless defined?(Factory)
