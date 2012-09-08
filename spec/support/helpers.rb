# encoding: utf-8

module Helpers
  def benchmark(name, &block)
    start = Time.now
    result = yield
    puts "#{name} (#{Time.now - start}s)"
    result
  end

  def cookies
    page.driver.browser.current_session.instance_variable_get("@rack_mock_session").cookie_jar.dup.tap do |cookie_jar|
      def cookie_jar.[](name)
        @cookies.find { |cookie| cookie.name == name.to_s }
      end
    end
  end

  def logout
    visit logout_path
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
end
