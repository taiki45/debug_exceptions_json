require 'rspec'

class DebugExceptionsJson
  module RSpec
    module Matchers
      # TODO: Accept symbol version
      def have_status_code(expected_code)
        StatusCodeMatcher.new(expected_code)
      end

      class StatusCodeMatcher
        def initialize(expected_code)
          @expected = expected_code
        end

        def failure_message
          message = "expected the response to have status code #{@expected} but it was #{@actual}."

          if dump_exception?(@response)
            [message, dumped_exception].join("\n\n")
          else
            message
          end
        end
        alias :failure_message_for_should :failure_message

        def failure_message_when_negated
          message = "expected the response not to have status code #{@expected} but it did"

          if dump_exception?(@response)
            [message, dumped_exception].join("\n\n")
          else
            message
          end
        end
        alias :failure_message_for_should_not :failure_message_when_negated

        def description
          "respond with numeric status code #{@expected}"
        end

        # response - A Rack::Response
        def matches?(response)
          @response = response
          @actual = response.status
          @actual == @expected
        end

        private

        # Set `@body` in default_error_response?
        def dump_exception?(response)
          response.server_error? && response.content_type.json? && default_error_response?(response)
        end

        def default_error_response?(response)
          @body = JSON.parse(response.body)
          @body.has_key?('error') &&
            @body['error'].has_key?('message') &&
            @body['error'].has_key?('backtrace')
        rescue JSON::ParserError
          false
        end

        def dumped_exception
          error = @body['error']

<<-EOM
ServerError:
  exception class:
    #{error['exception_class']}
  message:
    #{error['message']}
  short_backtrace:
    #{error['backtrace'][0..10].join("\n    ")}
EOM
        end
      end
    end
  end
end
