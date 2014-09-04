require 'spec_helper'

RSpec.describe 'server error dump', type: :request do

  # have_http_status matcher is only available in rspec-rails3
  require 'rspec/rails/version'
  unless ::RSpec::Rails::Version::STRING.split('.').first == "3"
    RSpec::Matchers.define :have_http_status do |expected|
      match do |actual|
        actual.status == expected
      end

      failure_message_for_should do |actual|
        "expected http status is #{expected}, but got #{actual.status}"
      end
    end
  end

  let(:params) { {} }

  context 'when client accepts application/json' do
    let(:env) { {'HTTP_ACCEPT' => 'application/json'} }

    context 'with no exception' do
      it 'successed' do
        get '/hello', params, env
        expect(response).to have_http_status(200)
      end
    end

    context 'with exception raised' do
      it 'responses error json' do
        get '/error', params, env

        # Turn on exception dumping by set status code as 200
        expect(response).to have_http_status(500)
      end
    end
  end

  context 'when client accepts text/html' do
    let(:env) { {'HTTP_ACCEPT' => 'text/html'} }

    context 'with no exception' do
      it 'successed' do
        get '/hello', params, env
        expect(response).to have_http_status(200)
      end
    end

    context 'with exception raised' do
      it 'responses error json' do
        get '/error', params, env
        expect(response).to have_http_status(500)
      end
    end
  end
end
