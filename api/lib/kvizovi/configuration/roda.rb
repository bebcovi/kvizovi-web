require "roda"
require "kvizovi/serializer"
require "sequel"

Roda.plugin :all_verbs
Roda.plugin :json, classes: [Array, Hash, Sequel::Model, Sequel::Dataset]
Roda.plugin :json_parser
Roda.plugin :symbolized_params
Roda.plugin :error_handler

class Roda::RodaRequest
  def convert_to_json(object)
    Kvizovi::Serializer.serialize(object)
  end
end
