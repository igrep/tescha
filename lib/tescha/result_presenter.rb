require 'tescha/readiness'
require 'tescha/test/constants'

module Tescha
  class ResultPresenter
    def initialize description, opts = {}
      setup_options! opts.dup
      @description = description
    end

    def setup_options! opts
      @output = opts.delete(:output) || $stdout
      @result_counter = opts.delete(:result_counter) || raise("Missing required option: :result_counter")

      raise "Unrecognized option(s): #{opts.keys.inspect}" unless opts.empty?
    end

    def write_statistical_message
      @output.write "#{@result_counter.tests.length} tests, #{@result_counter.failures.length} failures"
      @output.write ", #{@result_counter.skips.length} skipped" unless @result_counter.skips.empty?
      @output.write ".\n"
    end

    def write_results_of tests
      tests.each do|test|
        test.result_messages.each do|message|
          @output.write message
        end
      end
    end

    def after_test test
      case test.result
      when Test::SUCCESSFUL then @output.write('.'.freeze)
      when Test::FAILED     then @output.write('F'.freeze)
      when Test::SKIPPED    then @output.write('*'.freeze)
      else nil
      end
    end

    def after_execution
      write_results_of @result_counter.failures
      write_results_of @result_counter.skips
      write_statistical_message
    end

  end
end

if Tescha.ready? || __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  require 'tescha/test'
  require 'tescha/result_counter'
  require 'tescha/assertion/positive'
  require 'pp'
  include Tescha

  puts "\n---------------------------#initialize"

  puts 'An initial result lister'
  instance_in_test = ResultPresenter.new

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

  puts "\n---------------------------#append_test"
  puts 'given some tests with assertions including failed ones.'

  successful_test = Test.new 'a successful test in append_test'
  successful_test.append_result_of Assertion::Positive.new nil, :nil?

  failed_test1 = Test.new 'first failed test in append_test'
  failed_test1.append_result_of Assertion::Positive.new 0, :nil?

  failed_test2 = Test.new 'second failed test in append_test'
  failed_test2.append_result_of Assertion::Positive.new 0, :nil?

  instance_in_test = ResultPresenter.new
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

  puts "\n-------------------------------------------"
  puts 'given some tests with successful assertions and skipped tests.'

  successful_test1 = Test.new 'first successful test in append_test'
  successful_test1.append_result_of Assertion::Positive.new nil, :nil?
  successful_test2 = Test.new 'second successful test in append_test'
  successful_test2.append_result_of Assertion::Positive.new nil, :nil?
  skipped_test1 = Test.new 'first skipped test in append_test'
  skipped_test2 = Test.new 'second skipped test in append_test'

  instance_in_test = ResultPresenter.new
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

  puts "\n-------------------------------------------"
  puts 'given some tests with successful assertions.'

  successful_test1 = Test.new 'first successful test in append_test'
  successful_test1.append_result_of Assertion::Positive.new nil, :nil?
  successful_test2 = Test.new 'second successful test in append_test'
  successful_test2.append_result_of Assertion::Positive.new nil, :nil?

  instance_in_test = ResultPresenter.new
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

end
