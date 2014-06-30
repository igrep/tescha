require 'tescha/readiness'
require 'tescha/test/constants'

module Tescha
  class ResultLister
    attr_reader :last_result
    def initialize
      @last_result = nil
      @tests = []
      @failures = []
      @skips = []
    end
    def statistical_message
      message = "#{@tests.length} tests, #{@failures.length} failures"
      message << ", #{@skips.length} skipped" unless @skips.empty?
      message << '.'
    end
    def result_messages
      @failures.flat_map(&:result_messages).concat @skips.flat_map(&:result_messages)
    end
    def append_test test
      @last_result = test.result
      @tests << test
      case test.result
      when Test::FAILED
        @failures << test
      when Test::SKIPPED
        @skips << test
      end
    end
    def last_result_sign_in_progress
      case @last_result
      when Test::SUCCESSFUL then '.'.freeze
      when Test::FAILED     then 'F'.freeze
      when Test::SKIPPED    then '*'.freeze
      else nil
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

  puts 'An initial result lister'
  instance_in_test = ResultLister.new

  MetaTest.test(
    "  its statistical_message returns the count of tests and failed tests.",
    ( actual = instance_in_test.statistical_message ) == ( expected = "0 tests, 0 failures." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its result_messages returns an empty thing.",
    ( actual = instance_in_test.result_messages ).empty?,
      "The actual value: #{actual.inspect} is not empty."
  )

  MetaTest.test(
    "  its last_result is nil.",
    ( actual = instance_in_test.last_result ).nil?,
      "The actual value: #{actual.inspect} is not nil."
  )

  MetaTest.test(
    "  its last_result_sign_in_progress is nil.",
    ( actual = instance_in_test.last_result_sign_in_progress ).nil?,
      "The actual value: #{actual.inspect} is not nil."
  )

  puts "\n---------------------------#append_test"
  puts 'given some tests with assertions including failed ones.'

  successful_test = Test.new 'a successful test in append_test'
  successful_test.append_result_of Assertion::Positive.new nil, :nil?

  failed_test1 = Test.new 'first failed test in append_test'
  failed_test1.append_result_of Assertion::Positive.new 0, :nil?

  failed_test2 = Test.new 'second failed test in append_test'
  failed_test2.append_result_of Assertion::Positive.new 0, :nil?

  instance_in_test = ResultLister.new
  instance_in_test.append_test successful_test
  instance_in_test.append_test failed_test1
  instance_in_test.append_test failed_test2

  MetaTest.test(
    "  its statistical_message returns the count of tests and failed tests.",
    ( actual = instance_in_test.statistical_message ) == ( expected = "3 tests, 2 failures." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its result_messages returns failed tests' result_messages.",
    ( actual = instance_in_test.result_messages ) ==
      ( expected = failed_test1.result_messages + failed_test2.result_messages ),
      "The expected value:\n#{expected.pretty_inspect}\n" \
      "The actual value:\n#{actual.pretty_inspect}"
  )

  MetaTest.test(
    "  its last_result is FAILED.",
    ( actual = instance_in_test.last_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its last_result_sign_in_progress is 'F'.",
    ( actual = instance_in_test.last_result_sign_in_progress ) == ( expected = 'F' ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "\n-------------------------------------------"
  puts 'given some tests with successful assertions and skipped tests.'

  successful_test1 = Test.new 'first successful test in append_test'
  successful_test1.append_result_of Assertion::Positive.new nil, :nil?
  successful_test2 = Test.new 'second successful test in append_test'
  successful_test2.append_result_of Assertion::Positive.new nil, :nil?
  skipped_test1 = Test.new 'first skipped test in append_test'
  skipped_test2 = Test.new 'second skipped test in append_test'

  instance_in_test = ResultLister.new
  instance_in_test.append_test successful_test1
  instance_in_test.append_test successful_test2
  instance_in_test.append_test skipped_test1
  instance_in_test.append_test skipped_test2

  MetaTest.test(
    "  its statistical_message returns the count of tests and skipped tests.",
    ( actual = instance_in_test.statistical_message ) == ( expected = "4 tests, 0 failures, 2 skipped." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its result_messages returns skipped tests' result_messages.",
    ( actual = instance_in_test.result_messages ) ==
      ( expected = skipped_test1.result_messages + skipped_test2.result_messages ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its last_result is SKIPPED.",
    ( actual = instance_in_test.last_result ) == ( expected = Test::SKIPPED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its last_result_sign_in_progress is '*'.",
    ( actual = instance_in_test.last_result_sign_in_progress ) == ( expected = '*' ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "\n-------------------------------------------"
  puts 'given some tests with successful assertions.'

  successful_test1 = Test.new 'first successful test in append_test'
  successful_test1.append_result_of Assertion::Positive.new nil, :nil?
  successful_test2 = Test.new 'second successful test in append_test'
  successful_test2.append_result_of Assertion::Positive.new nil, :nil?

  instance_in_test = ResultLister.new
  instance_in_test.append_test successful_test1
  instance_in_test.append_test successful_test2

  MetaTest.test(
    "  its statistical_message returns the count of tests",
    ( actual = instance_in_test.statistical_message ) == ( expected = "2 tests, 0 failures." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its result_messages returns an empty thing.",
    ( actual = instance_in_test.result_messages ).empty?,
      "The actual value: #{actual.inspect} is not empty."
  )

  MetaTest.test(
    "  its last_result is SUCCESSFUL.",
    ( actual = instance_in_test.last_result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its last_result_sign_in_progress is '.'.",
    ( actual = instance_in_test.last_result_sign_in_progress ) == ( expected = '.' ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
