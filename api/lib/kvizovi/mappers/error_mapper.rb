require "kvizovi/mappers/base"

module Kvizovi
  module Mappers
    class ErrorMapper < Yaks::Mapper
      attributes :id, :status, :title
    end
  end
end
