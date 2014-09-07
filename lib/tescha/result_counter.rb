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

    def on_success test
      @tests << test
    end

    def on_failure test
      @tests << test
      @failures << test
    end

    def on_skip test
      @tests << test
      @skips << test
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
  subject = ResultCounter.new

  MetaTest.test(
    "  it has no tests.",
    (actual = subject.tests) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no failures.",
    (actual = subject.failures) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no skips.",
    (actual = subject.skips) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "\n---------------------------#on_success"
  puts 'given some successful tests.'

  subject = ResultCounter.new

  successful_test1 = Test.new 'first successful test in add_test'
  successful_test1.append_result_of Assertion::Positive.new nil, :nil?

  successful_test2 = Test.new 'second successful test in add_test'
  successful_test2.append_result_of Assertion::Positive.new nil, :nil?

  subject.on_success successful_test1
  subject.on_success successful_test2

  MetaTest.test(
    "  its tests are all added tests ordered as added.",
    (actual = subject.tests) == (expected = [successful_test1, successful_test2]),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no failures.",
    (actual = subject.failures) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no skips.",
    (actual = subject.skips) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "\n---------------------------#on_failure"
  puts 'given some failed tests.'

  subject = ResultCounter.new

  failed_test1 = Test.new 'first failed test in add_test'
  failed_test1.append_result_of Assertion::Positive.new 0, :nil?

  failed_test2 = Test.new 'second failed test in add_test'
  failed_test2.append_result_of Assertion::Positive.new 0, :nil?

  subject.on_failure failed_test1
  subject.on_failure failed_test2

  MetaTest.test(
    "  its tests are all added tests ordered as added.",
    (actual = subject.tests) == (expected = [failed_test1, failed_test2]),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its failures are all added tests ordered as added.",
    (actual = subject.failures) == (expected = [failed_test1, failed_test2]),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no skips.",
    (actual = subject.skips) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "\n---------------------------#on_skip"
  puts 'given some skipped tests.'

  subject = ResultCounter.new

  skipped_test1 = Test.new 'first skipped test in add_test'
  skipped_test2 = Test.new 'second skipped test in add_test'

  subject.on_skip skipped_test1
  subject.on_skip skipped_test2

  MetaTest.test(
    "  its tests are all added tests ordered as added.",
    (actual = subject.tests) == (expected = [skipped_test1, skipped_test2]),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  it has no failures.",
    (actual = subject.failures) == (expected = []),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  MetaTest.test(
    "  its skips are all added skips ordered as added.",
    (actual = subject.tests) == (expected = [skipped_test1, skipped_test2]),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
