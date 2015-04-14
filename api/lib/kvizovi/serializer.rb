module Kvizovi
  class Serializer
    def self.serialize(object)
      object.to_json(root: true)
    end
  end
end
