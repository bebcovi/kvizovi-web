module Kvizovi
  class Serializer
    def initialize(object)
      @object = object
    end

    def serialize(**options)
      json = @object.to_json(root: true, **options)
      json.sub!("kvizovi/models/", "")
      json
    end
  end
end
