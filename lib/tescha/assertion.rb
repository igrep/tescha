module Tescha
  class Assertion

    def initialize object, method_name, args = []
      @object = object
      @method_name = method_name
      @args = args

      @result = object.__send__ method_name, *args

      if @result
      end
    end

    def to_s
      @result_message
    end

  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  include Tescha

  puts "given a expression returning true"
  instance_in_test = Assertion.new 1, :==, 1
  MetaTest.test( 'its result is successful',
    ( actual = instance_in_test.successful? ) == ( expected = true ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'it does not have a result message',
    ( actual = instance_in_test.result_message ).nil?,
      "The expected value: #{expected.inspect} is NOT nil"
  )

  puts "given a expression returning a truthy value"
  instance_in_test = Assertion.new ['a'], :first
  MetaTest.test( 'its result is successful',
    ( actual = instance_in_test.successful? ) == ( expected = true ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'it does not have a result message',
    ( actual = instance_in_test.result_message ).nil?,
      "The expected value: #{expected.inspect} is NOT nil"
  )

  puts "given a expression returning false"
  instance_in_test = Assertion.new :a, :==, :b
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.successful? ) == ( expected = false ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expected value: :a' "\n" \
    'The actual value:   :b' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning nil"
  instance_in_test = Assertion.new {}, :[], :non_exisitng_key
  MetaTest.test( 'it has a detailed result message',
  )
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.successful? ) == ( expected = false ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expression {}[:non_exisitng_key] returned nil!' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
