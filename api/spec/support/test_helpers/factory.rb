module TestHelpers
  module Factory
    def create(name, additional_attributes = {})
      model_class, attributes = FACTORIES.fetch(name)
      model_class.create(attributes.merge(additional_attributes))
    end

    def build(name, additional_attributes = {})
      model_class, attributes = FACTORIES.fetch(name)
      model_class.new(attributes.merge(additional_attributes))
    end

    def attributes_for(name, additional_attributes = {})
      _, attributes = FACTORIES.fetch(name)
      attributes.merge(additional_attributes)
    end

    FACTORIES = {
      user: [Kvizovi::Models::User, {
        nickname: "Junky",
        email:    "janko.marohnic@gmail.com",
        password: "secret",
      }],
    }
  end
end
