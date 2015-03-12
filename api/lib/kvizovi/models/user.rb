require "sequel"

module Kvizovi
  module Models
    class User < Sequel::Model
      one_to_many :quizzes, key: :creator_id

      attr_accessor :password, :old_password

      def to_json(**options)
        super(
          only: [:id, :nickname, :email, :token],
          **options
        )
      end
    end
  end
end
