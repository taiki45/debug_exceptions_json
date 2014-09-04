$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "debug_exceptions_json/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "debug_exceptions_json"
  s.version     = DebugExceptionsJson::VERSION
  s.authors     = ["Taiki Ono"]
  s.email       = ["taiks.4559@gmail.com"]
  s.homepage    = "https://github.com/taiki45/debug_exceptions_json"
  s.summary     = "Show detail exception as json"
  s.description = "A Rack application for debugging in API server on Rails. Debug exception with json."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rspec", "~> 2.14.1"
  s.add_development_dependency "rails", "~> 4.1.5"
  s.add_development_dependency "sqlite3", "~> 1.3.9"
  s.add_development_dependency "rspec-rails", ">= 2.14.2"
  s.add_development_dependency "pry-rails", "~> 0.3.2"
  s.add_development_dependency "rspec-json_matcher", "~> 0.1.5"
end
