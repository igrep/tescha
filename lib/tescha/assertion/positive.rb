require 'tescha/readiness'
require 'tescha/assertion/base'

module Tescha
  module Assertion
    class Positive < Base
      def successful? result
        result
      end
    end
  end
end
