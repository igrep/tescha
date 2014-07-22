require 'tescha/readiness'
require 'tescha/test/constants'

module Tescha
  class ResultCounter
    attr_reader :tests, :failures, :skips
    def initialize
      @tests = []
      @failures = []
      @skips = []
    end

    def add_test test
      @tests << test
      case test.result
      when Test::FAILED
        @failures << test
      when Test::SKIPPED
        @skips << test
      end
    end

  end
end

if Tescha.ready? || __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  require 'tescha/test'
  require 'tescha/assertion/positive'
  require 'pp'
  include Tescha

  puts "\n---------------------------#initialize"

  puts 'An initial result counter'
  instance_in_test = ResultCounter.new

  MetaTest.test(
    "  it has no tests.",
    ( actual = instance_in_test.tests.size ) == ( expected = 0 ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no failures.",
    ( actual = instance_in_test.failures.size ) == ( expected = 0 ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no skips.",
    ( actual = instance_in_test.skips.size ) == ( expected = 0 ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "\n---------------------------#add_test"
  puts 'given some tests.'

  successful_test1 = Test.new 'first successful test in add_test'
  successful_test1.append_result_of Assertion::Positive.new nil, :nil?

  successful_test2 = Test.new 'second successful test in add_test'
  successful_test2.append_result_of Assertion::Positive.new nil, :nil?

  failed_test1 = Test.new 'first failed test in add_test'
  failed_test1.append_result_of Assertion::Positive.new 0, :nil?

  failed_test2 = Test.new 'second failed test in add_test'
  failed_test2.append_result_of Assertion::Positive.new 0, :nil?

  skipped_test1 = Test.new 'first skipped test in add_test'
  skipped_test2 = Test.new 'second skipped test in add_test'

  expected_tests = [
    successful_test1,
    successful_test2,
    failed_test1,
    failed_test2,
    skipped_test1,
    skipped_test2,
  ].shuffle!
  instance_in_test = ResultCounter.new
  expected_tests.each do|test|
    instance_in_test.add_test test
  end

  MetaTest.test(
    "  it tests are all added tests ordered as added.",
    (actual = instance_in_test.tests) == (expected_tests),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
