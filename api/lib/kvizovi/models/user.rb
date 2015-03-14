require "kvizovi/configuration/sequel"
require "kvizovi/configuration/refile"

module Kvizovi
  module Models
    class User < Sequel::Model
      one_to_many :quizzes, key: :creator_id

      extend Refile::Sequel::Attachment
      attachment :avatar

      attr_accessor :password

      def to_json(**options)
        super(
          only: [:id, :nickname, :avatar_url, :email, :token],
          **options
        )
      end
    end
  end
end
