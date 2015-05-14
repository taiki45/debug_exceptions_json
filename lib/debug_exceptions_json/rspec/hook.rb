class DebugExceptionsJson
  module RSpec
    module Hook
      def self.included(base)
        base.instance_eval do
          after do |example|
            # For RSpec2 compatibility
            if ::RSpec::Core::Version::STRING.start_with?("3.") || ::RSpec::Core::Version::STRING.start_with?("2.99")
              example.metadata[:response] = example.instance_exec { respond_to?(:response) && response }
            else
              # RSpec2 passes ExampleGroup::Nested_N
              nested = example
              nested.example.metadata[:response] = nested.example.instance_eval { respond_to?(:response) && response }
            end
          end
        end
      end
    end
  end
end
