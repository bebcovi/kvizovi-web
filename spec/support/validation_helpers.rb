module ValidationHelpers
  def valid!(model)
    model.any_instance.stub(:run_validations!) { true }
  end

  def invalid!(model)
    model.any_instance.stub(:run_validations!) { false }
  end
end

RSpec.configure do |config|
  config.include ValidationHelpers

  config.before(:each) do
    models = Dir[Rails.root.join("app/models/**/*.rb")].map do |model_path|
      File.basename(model_path, ".rb").camelize.constantize
    end
    models.each do |model|
      if model.ancestors.include?(ActiveRecord::Base)
        model.any_instance.stub(:run_validations!) { true }
      end
    end
  end

  config.before(:each, type: :model) do
    if described_class.ancestors.include?(ActiveRecord::Base)
      ancestors = described_class.ancestors.select { |c| c.is_a?(Class) }.take_while { |c| c != ActiveRecord::Base }
      ancestors.each do |model|
        model.any_instance.unstub(:run_validations!)
      end
    end
  end
end
