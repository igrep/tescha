module Tescha
  class ResultSet
    def initialize results
      @tests = []
      @assertions = []
      @failures = []
    end
    def to_s
      "#{@tests.length} tests, #{@assertions.length} assertions, #{@failures.length} failed assertions."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'

  puts 'An empty result set'
  instance_in_test = Tescha::ResultSet.new( [] )

  Tescha::MetaTest.test(
    "prints only the count of tests, assertions, and failed assertions.",
    ( actual = instance_in_test.to_s ) == ( expected = "0 tests, 0 assertions, 0 failed assertions." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
