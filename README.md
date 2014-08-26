DebugExceptionsJson
===================

A Rack application for debugging in API server on Rails. Debug exception with json.

## Requirements
- Ruby 2.0.0 or greater.
- Rails 3.2 or greater, Sinatra or another Rack-based application.

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

## Tips
### Your own app for debugging
You can specify aribitary logic for debugging. Give a proc to `DebugExceptionsJson`.
See code in `spec/dummy/config/application.rb`.

### When exception will apper?
The condition is almost same as ActionDispatch::DebugExceptions.

- `env['action_dispatch.show_exceptions']` is set as `true`. This is linked with `config.action_dispatch.show_exceptions` in Rails.
- `env['action_dispatch.show_detailed_exceptions']` is set as `true`. This is liked with `config.consider_all_requests_local` in Rails.
- `env['HTTP_ACCEPT'] matches with `application/json`.
