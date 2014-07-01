require 'tescha/test/constants'

module Tescha
  module Assertion
    class Base
      attr_reader :result_message, :as_result

      def initialize object, method_name, args = []
        result = object.__send__ method_name, *args
        successful = successful?(result)
        @as_result = successful ? Test::SUCCESSFUL : Test::FAILED
        @result_message =
          unless successful
            "Assertion failed.\n" \
              "The expression #{object.inspect}.#{method_name}(#{args.map( &:inspect ).join( ', ' )}) returned #{result.inspect}!\n"
          end
      end

      def successful?
        raise NotImplementedError
      end

    end
  end
end
