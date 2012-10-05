# encoding: utf-8

module IntegrationSpecHelpers
  def cookies
    page.driver.browser.current_session.instance_variable_get("@rack_mock_session").cookie_jar.dup.tap do |cookie_jar|
      def cookie_jar.[](name)
        @cookies.find { |cookie| cookie.name == name.to_s }
      end
    end
  end

  def login(user)
    login_path = send("#{user.class.name.underscore}_login_path")
    visit login_path

    fill_in "Korisničko ime", with: user.username
    fill_in "Lozinka", with: user.password
    click_on "Prijava"

    user
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
