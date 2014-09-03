class DebugExceptionsJson
  module RSpec
    class Formatter < ::RSpec::Core::Formatters::ProgressFormatter
      ::RSpec::Core::Formatters.register self, :dump_failures

      def dump_failures(notification)
        return if notification.failure_notifications.empty?

        colorizer = ::RSpec::Core::Formatters::ConsoleCodes
        formatted = "\nFailures:\n"

        notification.failure_notifications.each_with_index do |failure, index|
          formatted << failure.fully_formatted(index.next, colorizer)
          response = failure.example.metadata[:response]

          if response.server_error?
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

      private

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
