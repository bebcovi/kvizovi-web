# encoding: utf-8
require "rack/test"

module IntegrationSpecHelpers
  def login(name, attributes)
    visit login_path(type: name)

    fill_in "Korisničko ime", with: attributes[:username]
    fill_in "Lozinka", with: attributes[:password]
    click_on "Prijava"
  end

  def logout
    visit logout_path
  end
end

module UnitSpecHelpers
  def benchmark(name, &block)
    start = Time.now
    result = yield
    puts "#{name} (#{Time.now - start}s)"
    result
  end

  def stub_for_paperclip
    Paperclip.options[:log] = false
    stub_const("Rails", Module.new)
    Rails.stub(:root).and_return(ROOT)
  end

  def uploaded_file(filename, content_type)
    Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/#{filename}", content_type)
  end
end

module NullDBSpecHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  def setup_nulldb
    require "active_record"
    require "nulldb"
    require "activerecord-postgres-hstore/activerecord"
    require "activerecord-postgres-array"
    NullDB.nullify(schema: "#{ROOT}/db/schema.rb")
  end

  def teardown_nulldb
    begin
      NullDB.restore
    rescue ActiveRecord::ConnectionNotEstablished
    end
  end

  module ClassMethods
    def use_nulldb
      before(:all) { setup_nulldb }
      after(:all)  { teardown_nulldb }
    end
  end
end
