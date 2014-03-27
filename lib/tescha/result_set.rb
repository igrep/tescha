module Tescha
  class ResultSet
    def initialize
      @tests = []
      @assertions = []
      @failures = []
    end
    def summary
      "#{@tests.length} tests, #{@assertions.length} assertions, #{@failures.length} failed assertions."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  include Tescha

  puts 'An empty result set'
  instance_in_test = ResultSet.new

  MetaTest.test(
    "  its summary returns the count of tests, assertions, and failed assertions.",
    ( actual = instance_in_test.summary ) == ( expected = "0 tests, 0 assertions, 0 failed assertions." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
