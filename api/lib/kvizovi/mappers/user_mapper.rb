require "kvizovi/mappers/base"

module Kvizovi
  module Mappers
    class UserMapper < Base
      attributes :id, :nickname, :avatar_url, :email, :token

      has_many :quizzes
    end
  end
end
