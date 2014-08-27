require 'spec_helper'

require 'debug_exceptions_json/rspec/matchers'

RSpec.describe DebugExceptionsJson::RSpec::Matchers, type: :request do
  include DebugExceptionsJson::RSpec::Matchers

  let(:params) { {} }

  context 'when client accepts application/json' do
    let(:env) { {'HTTP_ACCEPT' => 'application/json'} }

    context 'with no exception' do
      it 'successed' do
        get '/hello', params, env
        expect(response).to have_status_code(200)
      end
    end

    context 'with exception raised' do
      it 'responses error json' do
        get '/error', params, env

        # Turn on exception dumping by set status code as 200
        expect(response).to have_status_code(500)
      end
    end
  end

  context 'when client accepts text/html' do
    let(:env) { {'HTTP_ACCEPT' => 'text/html'} }

    context 'with no exception' do
      it 'successed' do
        get '/hello', params, env
        expect(response).to have_status_code(200)
      end
    end

    context 'with exception raised' do
      it 'responses error json' do
        get '/error', params, env
        expect(response).to have_status_code(500)
      end
    end
  end
end
