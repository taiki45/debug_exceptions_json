# For RSpec2 compatibility
require 'rspec/core/formatters/progress_formatter'

class DebugExceptionsJson
  module RSpec
    class Formatter < ::RSpec::Core::Formatters::ProgressFormatter
      # For RSpec2 compatibility
      RSPEC3 = ::RSpec::Core::Version::STRING.split('.').first == "3"

      if RSPEC3
        ::RSpec::Core::Formatters.register self, :dump_failures
      end

      def dump_failures(notification = nil)
        if RSPEC3
          dump_failures_3(notification)
        else
          dump_failures_2
        end
      end

      private

      def dump_failures_3(notification)
        return if notification.failure_notifications.empty?

        colorizer = ::RSpec::Core::Formatters::ConsoleCodes
        formatted = "\nFailures:\n"

        notification.failure_notifications.each_with_index do |failure, index|
          formatted << failure.fully_formatted(index.next, colorizer)
          response = failure.example.metadata[:response]

          if response && response.server_error?
            begin
              e = JSON(response.body)['error']
            rescue JSON::ParserError
              e = {}
            end

            if e['exception_class'] && e['message'] && e['backtrace']
              formatted << error_to_dump_message(e)
            end
          end
        end

        output.puts formatted
      end

      def dump_failures_2
        return if failed_examples.empty?

        output.puts
        output.puts "Failures:"
        failed_examples.each_with_index do |example, index|
          output.puts
          pending_fixed?(example) ? dump_pending_fixed(example, index) : dump_failure(example, index)
          dump_backtrace(example)

          response = example.metadata[:response]

          if response && response.server_error?
            begin
              e = JSON(response.body)['error']
            rescue JSON::ParserError
              e = {}
            end

            if e['exception_class'] && e['message'] && e['backtrace']
              output.puts error_to_dump_message(e)
            end
          end
        end
      end

      # TODO: colorize server error dump?
      def error_to_dump_message(error)
<<-EOM

     ServerErrorDump:
       exception class:
         #{error['exception_class']}
       message:
         #{error['message']}
       short_backtrace:
         #{error['backtrace'][0..10].join("\n         ")}
EOM
      end
    end
  end
end
