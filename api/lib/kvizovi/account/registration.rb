require "kvizovi/account/password"

module Kvizovi
  class Account
    class Registration
      attr_reader :user

      VALID_FIELDS = [:nickname, :email, :password, :old_password]

      def self.create(user_class, attributes)
        user = user_class.new
        user.set_only(attributes, *VALID_FIELDS)
        new(user).save!
      end

      def initialize(user)
        @user = user
      end

      def save!
        encrypt_password!
        assign_confirmation_token!
        assign_auth_token!
        @user.save
        send_confirmation_email!

        @user
      end

      def confirm!
        @user.update(confirmed_at: Time.now, confirmation_token: nil)
      end

      def expired?
        !@user.confirmed_at && Time.now - @user.created_at > 3*24*60*60
      end

      def update!(attributes)
        old_password = attributes.delete(:old_password)
        @user.set_only(attributes, *VALID_FIELDS)
        if @user.password
          raise "password doesn't match current" if !password_matches?(old_password)
          encrypt_password!
        end
        @user.save

        @user
      end

      def destroy!
        @user.destroy
      end

      private

      def encrypt_password!
        Password.new(@user).encrypt!
      end

      def password_matches?(password)
        Password.new(@user).matches?(password)
      end

      def assign_confirmation_token!
        @user.confirmation_token = Kvizovi.generate_token
      end

      def assign_auth_token!
        @user.token = Kvizovi.generate_token
      end

      def send_confirmation_email!
        Kvizovi.mailer.send(:registration_confirmation, @user)
      end
    end
  end
end
