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
    "prints only the count of tests, assertions, and failed assertions.",
    ( actual = instance_in_test.to_s ) == ( expected = "0 tests, 0 assertions, 0 failed assertions." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts 'A result set with some results'
  instance_in_test = ResultSet.new
  instance_in_test.add(
    Test.new( 'test1', [
      Assertions.new( 1, [ :==, 1 ] ),
      Assertions.new( 1, [ :==, 0 ] ),
      Assertions.new( '', [ :empty? ] ),
    ] )
  )
  instance_in_test.add(
    Test.new( 'test2', [
      Assertions.new( 'foo', [ :==, 'bar' ] ),
      Assertions.new( nil, [ :nil? ] ),
    ] )
  )
end
