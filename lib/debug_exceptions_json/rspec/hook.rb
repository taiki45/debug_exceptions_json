class DebugExceptionsJson
  module RSpec
    module Hook
      def self.included(base)
        base.instance_eval do
          after do |example|
            example.metadata[:response] = example.instance_exec { response }
          end
        end
      end
    end
  end
end
