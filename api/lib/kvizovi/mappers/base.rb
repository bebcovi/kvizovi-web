require "yaks"
require "rack/utils"

module Kvizovi
  module Mappers
    class Base < Yaks::Mapper
      def self.has_one(name, **options)
        super name, **options, if: -> { include_association?(name) }
      end

      def self.has_many(name, **options)
        super name, **options, if: -> { include_association?(name) }
      end

      private

      def include_association?(name)
        includes.any? do |relationship|
          relationship.split(".")[mapper_stack.size] == name.to_s
        end
      end

      def includes
        query = Rack::Utils.parse_query(env["QUERY_STRING"])
        query["include"].to_s.split(",")
      end
    end
  end
end
