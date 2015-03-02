Gem::Specification.new do |gem|
  gem.name          = "kvizovi"
  gem.version       = "0.0.1"

  gem.required_ruby_version = ">= 2.2.0"

  gem.description   = "API for Kvizovi"
  gem.summary       = "The API endpoint used internally by http://kvizovi.org"
  gem.homepage      = "https://github.com/twin/kvizovi"

  gem.authors       = ["Janko Marohnić"]
  gem.email         = ["janko.marohnic@gmail.com"]

  gem.files         = Dir["README.md", "lib/**/*"]
  gem.require_path  = "lib"


  gem.add_dependency "sinatra", "~> 1.4"

  gem.add_dependency "sequel", "~> 4.20"
  gem.add_dependency "pg"

  gem.add_dependency "mail"

  # Utility
  gem.add_dependency "bcrypt", "~> 3.1"
  gem.add_dependency "unindent"
  gem.add_dependency "symbolize_keys_recursively", "~> 1.1"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rspec", "~> 3.1"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "timecop"
end
