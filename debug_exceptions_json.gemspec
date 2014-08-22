$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "debug_exceptions_json/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "debug_exceptions_json"
  s.version     = DebugExceptionsJson::VERSION
  s.authors     = ["Taiki Ono"]
  s.email       = ["taiks.4559@gmail.com"]
  s.homepage    = ""
  s.summary     = "Show detail exception as json"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.5"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
