module DebugExceptionsJson
  class RackApp
    DEFAULT_BUILDER = -> (exception, env) {
      [
        '500',
        { 'Content-Type' => 'application/json' },
        [
          {
            error: {
              message: exception.message,
              backtrace: exception.backtrace,
            },
          }.to_json
        ],
      ]
    }

    # app - A rack app
    # response_builder - A Proc which builds response
    #
    # response_builder takes 2 parameters:
    #   exception - An exception object
    #   env - A Hash
    #
    def initialize(app, response_builder = DEFAULT_BUILDER)
      @app = app
      @response_builder = response_builder
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      raise exception unless show_exception?(env)
      raise exception unless response_with_json?(env)

      @response_builder.call(exception, env)
    end

    private

    def show_exception?(env)
      env['action_dispatch.show_exceptions'] && env['action_dispatch.show_detailed_exceptions']
    end

    def response_with_json?(env)
      env['HTTP_ACCEPT'] =~ /application\/json/
    end
  end
end
