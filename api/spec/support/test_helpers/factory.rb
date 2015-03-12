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
      quiz: [Kvizovi::Models::Quiz, {
        name: "Game of Thrones",
      }],
      question: [Kvizovi::Models::Question, {
        type: "choice",
        title: "Who won the battle in Blackwater Bay?",
        content: {choices: ["Stannis Baratheon", "Tywin Lannister"], answer: "Tywin Lannister"},
      }],
      boolean_question: [Kvizovi::Models::Question, {
        type: "boolean",
        title: "Stannis Baratheon won the battle in Blackwater Bay.",
        content: {answer: false},
      }],
      choice_question: [Kvizovi::Models::Question, {
        type: "choice",
        title: "Who won the battle in Blackwater Bay?",
        content: {choices: ["Stannis Baratheon", "Tywin Lannister"], answer: "Tywin Lannister"},
      }],
      association_question: [Kvizovi::Models::Question, {
        type: "association",
        title: "Connect characters with families:",
        content: {associations: {"Lannister" => "Cercei", "Stark" => "Robb"}},
      }],
      text_question: [Kvizovi::Models::Question, {
        type: "text",
        title: "What's the name of King Baratheon's bastard son?",
        content: {answer: "Gendry"},
      }],
    }
  end
end
