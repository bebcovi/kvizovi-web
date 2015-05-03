require "sequel"
require "yaks"
require "json"
require "time"

require "kvizovi/error"

require "kvizovi/mappers/user_mapper"
require "kvizovi/mappers/quiz_mapper"
require "kvizovi/mappers/question_mapper"
require "kvizovi/mappers/gameplay_mapper"
require "kvizovi/mappers/dataset_mapper"
require "kvizovi/mappers/error_mapper"

module Kvizovi
  class Serializer
    CLASSES = [Array, Hash, Sequel::Model, Sequel::Dataset, Kvizovi::Error]

    def self.call(object, request)
      new(request).serialize(object)
    end

    def initialize(request)
      @request = request
    end

    def serialize(object)
      case object
      when Hash, Array
        object.to_json
      when Sequel::Dataset
        object = object.eager(*inclusion)
        yaks.call(object, env: @request.env)
      when Sequel::Model, Kvizovi::Error
        yaks.call(object, env: @request.env)
      end
    end

    private

    def yaks
      Yaks.new do
        default_format :json_api_modified
        mapper_namespace Kvizovi::Mappers
        map_to_primitive Date, Time, &:iso8601
        map_to_primitive Sequel::Postgres::JSONBHash, &:to_hash
      end
    end

    def inclusion
      includes = @request.params["include"].to_s.split(",")
      associations = includes.map do |relationship|
        levels = relationship.split(".")
        next levels.first if levels.size == 1
        levels.reverse.inject { |hash, rel| {rel => hash} }
      end
    end
  end
end

module Yaks
  class Format
    class JsonAPIModified < JsonAPI
      register :json_api_modified, :json, 'application/vnd.api+json'

      def call(resource, _env = nil)
        if resource.type == "error"
          {errors: resource.seq.map(&method(:serialize_error))}
        else
          output = super
          if resource.collection? && resource.links.any?
            output[:links] = resource.links.inject({}) { |h, l| h.update(l.rel => l.uri) }
          end
          output
        end
      end

      private

      def serialize_error(error_resource)
        error_resource.attributes
      end
    end
  end
end
