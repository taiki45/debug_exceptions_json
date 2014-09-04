DebugExceptionsJson
===================

A Rack application for debugging in API server on Rails. Debug exception with json.

## Requirements
- Ruby 2.0.0 or greater.

## Compatibilities
- Rails 3.2 or greater.
- RSpec 2.14.1 or greater.

## Getting Started
Add the following line to your application's Gemfile:

```ruby
gem 'debug_exceptions_json'
```

Use `DebugExceptionsJson` Rack app in your developement environments.

```ruby
# config/environments/developement.rb
config.middleware.insert_after ActionDispatch::DebugExceptions, DebugExceptionsJson

# config/environments/test.rb
config.middleware.insert_after ActionDispatch::DebugExceptions, DebugExceptionsJson
```

All done. Your request with `Accept: application/json` will be automatically shown exception as json.

## RSpec integration
DebugExceptionsJson provides RSpec hook and formatter to dump unexpectable server error in testing.

Setup:

```ruby
# In spec_helper.rb
require 'debug_exceptions_json/rspec'

RSpec.configure do |config|
  config.include DebugExceptionsJson::RSpec::Hook
  config.default_formatter = DebugExceptionsJson::RSpec::Formatter
end

# If you work with RSpec2
RSpec.configure do |config|
  config.include DebugExceptionsJson::RSpec::Hook
  config.formatter = DebugExceptionsJson::RSpec::Formatter
end
```

Dump like:

```
Failures:

  1) server error dump when client accepts application/json with exception raised responses error json
     Failure/Error: expect(response).to have_http_status(200)
       expected the response to have status code 200 but it was 500
     # ./spec/features/server_error_dump_spec.rb:21:in `block (4 levels) in <top (required)>'

     ServerErrorDump:
       exception class:
         HelloController::TestError
       message:
         test error
       short_backtrace:
         <backtrace is here>
```

Notice: server error dump only appers when you use default debug logic.

## Tips
### Your own app for debugging
You can specify aribitary logic for debugging. Give a proc to `DebugExceptionsJson` like:

```ruby
config.middleware.insert_after(
  ActionDispatch::DebugExceptions,
  DebugExceptionsJson,
  -> (e, env) {
    [
      '500',
      { 'Content-Type' => 'application/json' },
      [{ message: e.message, backtrace: e.backtrace, }.to_json],
    ]
  }
)
```


### When exception will apper?
The condition is almost same as ActionDispatch::DebugExceptions.

- `env['action_dispatch.show_exceptions']` is set as `true`. This is linked with `config.action_dispatch.show_exceptions` in Rails.
- `env['action_dispatch.show_detailed_exceptions']` is set as `true`. This is liked with `config.consider_all_requests_local` in Rails.
- `env['HTTP_ACCEPT'] matches with `application/json`.

If you are working in non-Rails app, please set these env variable properly.


## Developement Tips
### Switch RSpec version
```
# Use RSpec2
rm Gemfile.lock
USE_RSPEC2=1 bundle update

# Use RSpec3
rm Gemfile.lock
bundle update
```
