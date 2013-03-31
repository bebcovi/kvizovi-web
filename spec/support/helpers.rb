require "rack/test"
require "fileutils"

module Helpers
  extend ActiveSupport::Concern

  included do
    include SpecHelpers
    include CapybaraHelpers
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

  module ClassMethods
    def benchmark_examples
      around(:each) { |example| benchmark { example.run } }
    end
  end
end

module SpecHelpers
  extend ActiveSupport::Concern

  def invalidate(object)
    change{object.valid?}.to(false)
  end

  def revalidate(object)
    change{object.valid?}.to(true)
  end

  module ClassMethods
    def reset_attributes(attributes)
      after do
        metadata = example.metadata
        until metadata[:description_args].first =~ /^#\w+$/ or metadata[:example_group] == nil
          metadata = metadata[:example_group]
        end
        unless metadata.nil?
          attribute = metadata[:description_args].first.delete("#").to_sym
          @it.send("#{attribute}=", attributes[attribute])
        end
      end
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

def benchmark(name = nil, &block)
  start = Time.now
  result = yield
  puts [name, "(#{Time.now - start}s)"].compact.join(" ")
  result
end
