module Kvizovi
  class Serializer
    def self.call(object, env)
      json = object.to_json(root: true)
      json.sub!("kvizovi/models/", "")
      json
    end
  end
end
