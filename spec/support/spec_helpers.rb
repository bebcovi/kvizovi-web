# encoding: utf-8

module IntegrationSpecHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  def cookies
    page.driver.browser.current_session.instance_variable_get("@rack_mock_session").cookie_jar.dup.tap do |cookie_jar|
      def cookie_jar.[](name)
        @cookies.find { |cookie| cookie.name == name.to_s }
      end
    end
  end

  def login(name, attributes)
    visit send("#{name}_login_path")

    fill_in "Korisničko ime", with: attributes[:username]
    fill_in "Lozinka", with: attributes[:password]
    click_on "Prijava"
  end

  def logout
    visit logout_path
  end

  module ClassMethods
  end
end

module UnitSpecHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  def benchmark(name, &block)
    start = Time.now
    result = yield
    puts "#{name} (#{Time.now - start}s)"
    result
  end

  def ordinalize(argument)
    if argument.is_a?(Integer)
      ORDINALS[argument]
    elsif argument.is_a?(Enumerable)
      argument.map { |number| ORDINALS[number] }
    end
  end

  ORDINALS = {
    1 => "Prvi",
    2 => "Drugi",
    3 => "Treći",
    4 => "Četvrti",
    5 => "Peti",
    6 => "Šesti",
    7 => "Sedmi",
    8 => "Osmi"
  }

  module ClassMethods
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
