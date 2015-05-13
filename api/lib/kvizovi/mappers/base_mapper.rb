require "yaks"
require "rack/utils"

module Kvizovi
  module Mappers
    class BaseMapper < Yaks::Mapper
      def self.has_one(name, **options)
        super name, **options, if: -> { object.associations.key?(name) }
      end

      def self.has_many(name, **options)
        super name, **options, if: -> { object.associations.key?(name) }
      end
    end
  end
end
