require 'spec_helper'

RSpec.describe DebugExceptionsJson, type: :request do
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
        expect(response).to have_http_status(500)
        expect(response.body).to be_json_as(
          error: {
            exception_class: 'HelloController::TestError',
            message: 'test error',
            backtrace: Array,
          }
        )
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
        expect(response.body).not_to be_json
      end
    end
  end
end
