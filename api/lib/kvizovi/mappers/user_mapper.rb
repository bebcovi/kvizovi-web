require "kvizovi/mappers/base_mapper"

module Kvizovi
  module Mappers
    class UserMapper < BaseMapper
      attributes :id, :nickname, :avatar_url, :email, :token

      has_many :quizzes
    end
  end
end
