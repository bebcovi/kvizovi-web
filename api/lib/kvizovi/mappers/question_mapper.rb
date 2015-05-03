require "kvizovi/mappers/base"

module Kvizovi
  module Mappers
    class QuestionMapper < Base
      attributes :id, :kind, :title, :content, :image, :hint, :position
    end
  end
end
