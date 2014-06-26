require 'tescha/readiness'
require 'tescha/assertion/base'

module Tescha::Assertion
  def self.new *args
    ::Tescha::Assertion::Positive.new(*args)
  end
end

if Tescha.ready? || __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  include Tescha

  puts "given a expression returning true"
  instance_in_test = Assertion.new 1, :==, [1]
  MetaTest.test( 'its result is successful',
    ( actual = instance_in_test.as_result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'it does not have a result message',
    ( actual = instance_in_test.result_message ).nil?,
      "The actual value: #{actual.inspect} is NOT nil"
  )

  puts "given a expression returning a truthy value"
  instance_in_test = Assertion.new ['a'], :first
  MetaTest.test( 'its result is successful',
    ( actual = instance_in_test.as_result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'it does not have a result message',
    ( actual = instance_in_test.result_message ).nil?,
      "The actual value: #{actual.inspect} is NOT nil"
  )

  puts "given a expression returning false"
  instance_in_test = Assertion.new :a, :==, [:b]
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.as_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expression :a.==(:b) returned false!' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning nil"
  instance_in_test = Assertion.new( {}, :[], [:non_exisitng_key] )
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.as_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expression {}.[](:non_exisitng_key) returned nil!' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
