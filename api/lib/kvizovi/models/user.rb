require "sequel"

module Kvizovi
  module Models
    class User < Sequel::Model
      attr_accessor :password, :old_password

      def to_json(**options)
        super(
          root: "user",
          only: [:id, :nickname, :email, :token],
          **options
        )
      end
    end
  end
end
