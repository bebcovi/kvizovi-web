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
        encrypt!
        @user.password_reset_token = nil
        @user.save
      end

      def matches?(password)
        Kvizovi.password(@user.encrypted_password) == password
      end

      def encrypt!
        @user.encrypted_password = Kvizovi.hash(@user.password)
      end

      private

      def send_reset_instructions_email!
        Kvizovi.mailer.send(:password_reset_instructions, @user)
      end
    end
  end
end
