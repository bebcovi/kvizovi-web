# http://collectiveidea.com/blog/archives/2012/01/05/capybara-cucumber-and-how-the-cookie-crumbles/
require "cucumber/rspec/doubles"

module Capybara
  class Session
    def cookies
      @cookies ||= begin
        secret = Rails.application.config.secret_token
        cookies = ActionDispatch::Cookies::CookieJar.new(secret)
        cookies.stub(:close!)
        cookies
      end
    end
  end
end

Before do
  request = ActionDispatch::Request.any_instance
  request.stub(:cookie_jar).and_return(page.cookies)
  request.stub(:cookies).and_return(page.cookies)
end

After do
  page.cookies.clear
end
