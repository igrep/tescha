require 'tescha/readiness'
require 'tescha/assertion/base'

module Tescha
  module Assertion
    class Nil < Base
      def successful? result
        result.equal? nil
      end
    end
  end
end

if Tescha.ready? || __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  include Tescha

  puts "given a expression returning false"
  instance_in_test = Assertion::Nil.new 1, :==, [0]
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.as_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expression 1.==(0) returned false!' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning nil"
  instance_in_test = Assertion::Nil.new [], :first
  MetaTest.test( 'its result is successful',
    ( actual = instance_in_test.as_result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'it does not have a result message',
    ( actual = instance_in_test.result_message ).nil?,
      "The actual value: #{actual.inspect} is NOT nil"
  )

  puts "given a expression returning true"
  instance_in_test = Assertion::Nil.new :a, :==, [:a]
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.as_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expression :a.==(:a) returned true!' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning a truthy value"
  instance_in_test = Assertion::Nil.new( 1, :nonzero? )
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.as_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  failure = 'Assertion failed.' "\n" \
    'The expression 1.nonzero?() returned 1!' "\n"
  MetaTest.test( 'it has a detailed result message',
    ( actual = instance_in_test.result_message ) == ( expected = failure ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
