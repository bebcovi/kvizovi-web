require "rack/test"
require "active_support/core_ext/string/inflections"

module Helpers
  def self.included(base)
    base.send(:include, SpecHelpers)
    base.send(:include, CapybaraHelpers)

    base.extend(ClassMethods)
  end

  def uploaded_file(filename, content_type)
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/#{filename}"), content_type)
  end

  def transaction_with_rollback(&block)
    ActiveRecord::Base.transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end

  module ClassMethods
    def benchmark_examples
      around(:each) { |example| benchmark { example.run } }
    end
  end
end

module SpecHelpers
  def invalidate(object)
    change{object.valid?}.to(false)
  end

  def revalidate(object)
    change{object.valid?}.to(true)
  end
end

module CapybaraHelpers
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

def benchmark(name = nil, &block)
  start = Time.now
  result = yield
  puts [name, "(#{Time.now - start}s)"].compact.join(" ")
  result
end
