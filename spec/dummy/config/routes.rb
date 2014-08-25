Rails.application.routes.draw do
  get '/hello', controller: :hello, action: :hello
  get '/error', controller: :hello, action: :error
end
