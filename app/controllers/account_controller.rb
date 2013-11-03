class AccountController < ApplicationController
  before_filter :authenticate_user!

  def dashboard
    render text: "account#dashboard", layout: true
  end
end
