class DebugExceptionsJson
  module RSpec
    module Hook
      def self.included(base)
        base.instance_eval do
          after do |example|
            # For RSpec2 compatibility
            if ::RSpec::Core::Version::STRING.split('.').first == "3"
              example.metadata[:response] = example.instance_exec { response }
            else
              # RSpec2 passes ExampleGroup::Nested_N
              nested = example
              nested.example.metadata[:response] = nested.example.instance_eval { response }
            end
          end
        end
      end
    end
  end
end
