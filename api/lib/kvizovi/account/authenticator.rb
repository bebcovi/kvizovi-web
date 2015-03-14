require "kvizovi/account/password"

module Kvizovi
  class Account
    class Authenticator
      def self.authenticate(user_class, type, object)
        user = new(user_class).send(:authenticate, type, object)
        raise Kvizovi::Unauthorized, type if user.nil?
        user
      end

      def initialize(user_class)
        @user_class = user_class
      end

      def authenticate(type, object)
        user = send("authenticate_from_#{type}", object)
        raise Kvizovi::Unauthorized, :expired if user && registration_expired?(user)
        user
      end

      protected

      def authenticate_from_email(email)
        @user_class.find(email: email)
      end

      def authenticate_from_credentials(credentials)
        if credentials[:email]
          user = @user_class.find(email: credentials[:email])
          user if user && password_matches?(user, credentials[:password])
        elsif credentials[:token]
          authenticate_from_token(credentials[:token])
        end
      end

      def authenticate_from_token(token)
        @user_class.find(token: token)
      end

      def authenticate_from_confirmation_token(token)
        @user_class.first!(confirmation_token: token)
      end

      def authenticate_from_password_reset_token(token)
        @user_class.first!(password_reset_token: token)
      end

      private

      def password_matches?(user, password)
        Password.new(user).matches?(password)
      end

      def registration_expired?(user)
        Registration.new(user).expired?
      end
    end
  end
end
