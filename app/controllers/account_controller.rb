class AccountController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    render text: "account#dashboard", layout: true
  end
end
