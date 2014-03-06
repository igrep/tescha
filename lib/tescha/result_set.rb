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
      Assertions.new( 1, :==, [1] ),
      Assertions.new( '', :empty? ),
      Assertions.new( 'a', :empty? ),
    ] )
  )
  instance_in_test.add(
    Test.new( 'test2', [
      Assertions.new( 'foo', :==, ['bar'] ),
      Assertions.new( nil, :nil? ),
    ] )
  )

  failure2 = "test1:\n" \
    '  Assertion failed.' "\n" \
    '  "a".empty? unexpectedly returned false.' "\n"
  failure2 = "test2:\n" \
    '  Assertion failed.' "\n" \
    '  The expected value: "foo"' "\n" \
    '  The actual value:   "bar"' "\n"
  MetaTest.test(
    "  generates each failure in detail",
    ( actual = instance_in_test.each_result_message.to_a ) == ( expected = [failure1, failure2]),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its summary returns the count of tests, assertions, and failed assertions.",
    ( actual = instance_in_test.summary ) == ( expected = "2 tests, 5 assertions, 2 failed assertions." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
