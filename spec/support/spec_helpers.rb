# encoding: utf-8
require "rack/test"
require "active_support/core_ext/string/inflections"

module SpecHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  def login_as(user)
    visit login_path(type: user.class.name.underscore)

    fill_in "Korisničko ime", with: user.username
    fill_in "Lozinka", with: user.password
    click_on "Prijava"
  end

  def logout
    visit logout_path
  end

  def uploaded_file(filename, content_type)
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/#{filename}"), content_type)
  end

  def invalidate(object)
    change{object.valid?}.to(false)
  end

  def revalidate(object)
    change{object.valid?}.to(true)
  end

  def click_on(*args)
    super
    expect(page).not_to have_content("translation missing")
  end

  module ClassMethods
    def benchmark_examples
      around(:each) { |example| benchmark { example.run } }
    end
  end
end

module NullDBSpecHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  def setup_nulldb
    NullDB.nullify(schema: Rails.root.join("db/schema.rb"))
  end

  def teardown_nulldb
    NullDB.restore
  end

  def use_nulldb(&block)
    setup_nulldb
    block.call
    teardown_nulldb
  end

  module ClassMethods
    def use_nulldb
      before(:all) { setup_nulldb }
      after(:all)  { teardown_nulldb }
    end
  end
end

def benchmark(name = nil, &block)
  start = Time.now
  result = yield
  puts [name, "(#{Time.now - start}s)"].compact.join(" ")
  result
end
