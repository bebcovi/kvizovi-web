require "rack/test"
require "factory_girl"
require "delegate"
require "uri"

module Helpers
  module Generic
    extend ActiveSupport::Concern

    FIXTURES_PATH = "spec/support/fixtures"

    def uploaded_file
      Rack::Test::UploadedFile.new(photo_path, "image/jpeg")
    end

    def photo_path
      Rails.root.join(FIXTURES_PATH, "files/photo.jpg")
    end

    def sent_emails
      ActionMailer::Base.deliveries
    end
  end

  module Controller
    extend ActiveSupport::Concern
    include Devise::TestHelpers

    included do
      # Devise::TestHelpers does this, but only for test/unit
      before do
        setup_controller_for_warden
        warden
      end
    end

    def login_as(user_type)
      @user = create(user_type)
      sign_in(@user)
    end

    def current_user
      @user
    end
  end

  module Integration
    extend ActiveSupport::Concern

    def register(type, attributes = {})
      CapybaraUser.new(create(type, attributes), self)
    end

    def login(user)
      visit send("new_#{user.type}_session_path")
      fill_in "Korisničko ime", with: user.username
      fill_in "Lozinka",        with: user.password
      submit
    end

    def get_user(user)
      CapybaraUser.new(user, self)
    end

    def refresh
      visit current_path
    end

    def select_from(locator, value)
      select value, from: locator
    end

    def choose_under(label_text, locator)
      label = find("label", text: label_text)
      within(label.parent) { choose locator }
    end

    def navbar
      find(".navbar")
    end

    def submit
      find("[type='submit']").click
    end

    class CapybaraUser < SimpleDelegator
      def initialize(user, context)
        @context = context
        super(user)
      end

      def logged_in?
        @context.navbar.has_content?(username)
      end

      def logged_out?
        @context.navbar.has_no_content?(username)
      end
    end
  end
end
