DebugExceptionsJson
===================

A Rack application for debugging in API server on Rails. Debug exception with json.

## Requirements
- Ruby 2.0.0 or greater.
- Rails 3.2 or greater.

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

## Rspec matchers
DebugExceptionsJson provides rspec matchers to handle unexpectable server error in testing.
By using these matchers, you can dump server errors.

Example:

```ruby
it 'returens 200' do
  get '/success', params, env
  expect(response).to have_status_code(200)

  # Other matching goes here...
end
```

When something went wrong in `/success`, `have_status_code` matcher dumps server error in failure message like this.

```
Failure/Error: expect(response).to have_status_code(200)
  expected the response to have status code 200 but it was 500.

  ServerError:
    exception class:
      HelloController::TestError
    message:
      test error
    short_backtrace:
      <backtrace is here>
```

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
