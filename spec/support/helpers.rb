require "rack/test"
require "fileutils"

module Helpers
  extend ActiveSupport::Concern

  included do
    include CapybaraHelpers
    include RSpecHelpers
  end

  def uploaded_file(filename, content_type)
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/#{filename}"), content_type)
  end

  def create_file(filename, content_type, options = {}, &block)
    file_path = Rails.root.join("tmp/#{filename}")
    begin
      File.open(file_path, "w") do |f|
        size = options[:size] || 0
        until f.size >= size
          f.write "a" * 10000
        end
      end
      yield Rack::Test::UploadedFile.new(file_path, content_type)
    ensure
      FileUtils.rm(file_path) if File.exists?(file_path)
    end
  end
end

module RSpecHelpers
  extend ActiveSupport::Concern


  module ClassMethods
    def benchmark_examples
      around(:each) { |example| benchmark { example.run } }
    end

    def school!
      before { request.host = "school.example.com" }
    end

    def student!
      before { request.host = "student.example.com" }
    end
  end
end

module CapybaraHelpers
  extend ActiveSupport::Concern

  def login_as(user)
    visit login_url(subdomain: user.type)

    fill_in "Korisničko ime", with: user.username
    fill_in "Lozinka", with: user.password
    click_on "Prijava"
  end

  def logout
    click_on "Odjava"
  end
end

RSpec.configure do |config|
  config.include Helpers
end

def benchmark(name = nil, &block)
  start = Time.now
  result = yield
  puts [name, "(#{Time.now - start}s)"].compact.join(" ")
  result
end
