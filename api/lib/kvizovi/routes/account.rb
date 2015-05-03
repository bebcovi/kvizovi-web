require "kvizovi/mediators/account"

module Kvizovi
  class App
    route "account" do |r|
      r.get true do
        Mediators::Account.authenticate(authorization.value)
      end

      r.post true do
        Mediators::Account.register!(resource(:user))
      end

      r.patch true do
        Mediators::Account.new(current_user).update!(resource(:user))
      end

      r.delete true do
        Mediators::Account.new(current_user).destroy!
      end

      r.patch "confirm" do
        Mediators::Account.confirm!(params[:token])
      end

      r.post "password" do
        Mediators::Account.reset_password!(params[:email])
      end

      r.patch "password" do
        Mediators::Account.set_password!(params[:token], resource(:user))
      end
    end
  end
end
