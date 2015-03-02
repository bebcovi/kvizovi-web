require "kvizovi/mailer"

require "bcrypt"

module Kvizovi
  class Account
    class Password
      def initialize(user)
        @user = user
      end

      def reset!
        @user.update(password_reset_token: Kvizovi.generate_token)
        send_reset_instructions_email!
      end

      def set!(attributes)
        @user.set_only(attributes, :password)
        raise Kvizovi::Error, {user: @user.errors} if not valid?

        encrypt!
        @user.password_reset_token = nil
        @user.save
      end

      def matches?(password)
        ::BCrypt::Password.new(@user.encrypted_password) == password
      end

      def encrypt!
        @user.encrypted_password = ::BCrypt::Password.create(@user.password)
      end

      private

      def valid?
        validate!
        @user.errors.empty?
      end

      def validate!
        @user.validates_presence [:password]
      end

      def send_reset_instructions_email!
        Kvizovi::Mailer.new(@user).send(:password_reset_instructions)
      end
    end
  end
end
