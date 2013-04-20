require "factory_girl"

FactoryGirl.find_definitions

module FactoryGirl
  class Strategy::CreateWithoutValidation < Strategy::Create
    def result(evaluation)
      evaluation.object.tap do |instance|
        evaluation.notify(:after_build, instance)
        evaluation.notify(:before_create, instance)
        instance.save(validate: false)
        evaluation.notify(:after_create, instance)
      end
    end
  end

  register_strategy(:create_without_validation, Strategy::CreateWithoutValidation)
end

Factory = FactoryGirl
