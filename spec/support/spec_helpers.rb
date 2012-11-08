# encoding: utf-8

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
end

module NullDBSpecHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  def setup_nulldb
    require "nulldb"
    require "activerecord-postgres-hstore/activerecord"
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
