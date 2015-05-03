require "kvizovi/mappers/base"

module Kvizovi
  module Mappers
    class QuizMapper < Base
      attributes :id, :name, :category, :image, :questions_count,
        :created_at, :updated_at

      has_one  :creator, mapper: UserMapper
      has_many :questions
    end
  end
end
