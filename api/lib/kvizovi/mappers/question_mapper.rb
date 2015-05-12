require "kvizovi/mappers/base"

module Kvizovi
  module Mappers
    class QuestionMapper < Base
      attributes :id, :type, :title, :content, :image, :hint, :position
    end
  end
end
