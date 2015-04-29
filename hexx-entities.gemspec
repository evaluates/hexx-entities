$:.push File.expand_path("../lib", __FILE__)
require "hexx/entities/version"

Gem::Specification.new do |gem|

  gem.name        = "hexx-entities"
  gem.version     = Hexx::Entities::VERSION.dup
  gem.author      = "Andrew Kozin"
  gem.email       = "andrew.kozin@gmail.com"
  gem.homepage    = "https://github.com/nepalez/hexx-entities"
  gem.summary     = "Base class for domain entities"
  gem.license     = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = "~> 2.1"

  gem.add_runtime_dependency "attestor", "~> 2.2"
  gem.add_runtime_dependency "eigindir", "~> 0.0"

  gem.add_development_dependency "hexx-rspec", "~> 0.4"

end # Gem::Specification
