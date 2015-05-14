source "https://rubygems.org"

gemspec

if ENV['USE_RSPEC2']
  gem "rspec", "~> 2.14.1"
  gem "rspec-rails", "~> 2.14.2"
elsif ENV['USE_RSPEC299']
  gem "rspec", "~> 2.99.0"
  gem "rspec-rails", "~> 2.99.0"
else
  gem "rspec", "~> 3.0"
  gem "rspec-rails", "~> 3.0"
end
