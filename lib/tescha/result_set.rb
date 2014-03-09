module Tescha
  class ResultSet
    def initialize
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
  include Tescha

  puts 'An empty result set'
  instance_in_test = ResultSet.new

  MetaTest.test(
    "  its summary returns the count of tests, assertions, and failed assertions.",
    ( actual = instance_in_test.summary ) == ( expected = "0 tests, 0 assertions, 0 failed assertions." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts 'A result set with one failure in each test'
  instance_in_test = ResultSet.new
  instance_in_test.add(
    Test.new( 'test1', [
      Assertion.new( 1, :==, [1] ),
      Assertion.new( '', :empty? ),
      Assertion.new( 'a', :empty? ),
    ] )
  )
  instance_in_test.add(
    Test.new( 'test2', [
      Assertion.new( 'foo', :==, ['bar'] ),
      Assertion.new( nil, :nil? ),
    ] )
  )

  MetaTest.test(
    "  its summary returns the count of tests, assertions, and failed assertions.",
    ( actual = instance_in_test.summary ) == ( expected = "2 tests, 5 assertions, 2 failed assertions." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
