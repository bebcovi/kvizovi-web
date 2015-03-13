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
        validate!(:create)
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
        @user.set_only(attributes, *VALID_FIELDS)
        validate!(:update)
        encrypt_password! if @user.password
        @user.save

        @user
      end

      def destroy!
        @user.destroy
      end

      private

      def validate!(context)
        send("validate_#{context}")
        raise Kvizovi::Error, {user: @user.errors} if @user.errors.any?
      end

      def validate_create
        @user.validates_presence [:nickname, :email, :password]
        @user.validates_unique :email
      end

      def validate_update
        @user.validates_presence [:nickname, :email]
        @user.validates_unique :email
        if @user.password && !password_matches?(@user.old_password)
          @user.errors.add(:old_password, "doesn't match current")
        end
      end

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
