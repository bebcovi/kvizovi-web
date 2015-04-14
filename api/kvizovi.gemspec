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


  # API
  gem.add_dependency "roda", "~> 2.2"

  # Database
  gem.add_dependency "sequel", "~> 4.21"
  gem.add_dependency "pg"

  # Images
  gem.add_dependency "refile", "~> 0.5"
  gem.add_dependency "refile-sequel"
  gem.add_dependency "mini_magick", "~> 4.2"

  # Email
  gem.add_dependency "mail"

  # Utility
  gem.add_dependency "bcrypt", "~> 3.1"
  gem.add_dependency "unindent"

  # Testing
  gem.add_development_dependency "rspec", "~> 3.1"
  gem.add_development_dependency "timecop"
  gem.add_development_dependency "rack-test"
end
