require 'active_support/deprecation'
require 'active_support/logger'

class DebugExceptionsJson
  DEFAULT_BUILDER = -> (exception, env) {
    [
      '500',
      { 'Content-Type' => 'application/json' },
      [
        {
          error: {
            exception_class: exception.class.name,
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

    log_error(exception, env)
    @response_builder.call(exception, env)
  end

  private

  def show_exception?(env)
    env['action_dispatch.show_exceptions'] && env['action_dispatch.show_detailed_exceptions']
  end

  def response_with_json?(env)
    env['HTTP_ACCEPT'] =~ /application\/json/
  end

  def log_error(exception, env)
    logger = logger(env)
    return unless logger

    ActiveSupport::Deprecation.silence do
      message = "\n#{exception.class} (#{exception.message}):\n"
      message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
      message << "  " << exception.backtrace.join("\n  ")
      logger.fatal("#{message}\n\n")
    end
  end

  def logger(env)
    env['action_dispatch.logger'] || stderr_logger
  end

  def stderr_logger
    @stderr_logger ||= ActiveSupport::Logger.new($stderr)
  end
end
