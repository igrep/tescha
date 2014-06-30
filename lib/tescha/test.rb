require 'tescha/readiness'

module Tescha
  class Test

    def initialize description
      @description = description
      @result_switch = ResultSwitch.new
      @result_messages = []
    end

    def result_messages
      if @result_switch.initial?
        ["#@description:\nWARNING: No assertions.\n"]
      else
        @result_messages
      end
    end

    def result
      @result_switch.final_result
    end

    def append_result_of action
      @result_switch.send action.as_result
      @result_messages << "#@description:\n#{action.result_message}" if action.result_message
    end

  end

end

require 'tescha/test/result_switch'

if Tescha.ready? || __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  require 'tescha/assertion/positive'
  include Tescha

  puts 'An empty test'
  instance_in_test = Test.new 'empty test'
  warning = "empty test:\n" \
    'WARNING: No assertions.' "\n"
  MetaTest.test( 'it has one warning message',
    ( actual = instance_in_test.result_messages ) == ( expected = [warning] ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its result is skipped',
    ( actual = instance_in_test.result ) == ( expected = Test::SKIPPED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "A test with one successful test"
  instance_in_test = Test.new 'successfull1'
  instance_in_test.append_result_of Assertion::Positive.new( [], :empty? )
  MetaTest.test( 'it has no failure message',
    ( actual = instance_in_test.result_messages ).empty?,
    "The actual value: #{actual.inspect} is NOT empty!"
  )
  MetaTest.test( 'its result is SUCCESSFUL',
    ( actual = instance_in_test.result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "A test with all successful tests"
  instance_in_test = Test.new 'successfull2'
  instance_in_test.append_result_of Assertion::Positive.new( 'Foo', :==, ['Foo'] )
  instance_in_test.append_result_of Assertion::Positive.new( -1, :<, 0 )
  instance_in_test.append_result_of Assertion::Positive.new( [1, 2], :include?, 2 )
  MetaTest.test( 'it has no failure message',
    ( actual = instance_in_test.result_messages ).empty?,
    "The actual value: #{actual.inspect} is NOT empty!"
  )
  MetaTest.test( 'its result is SUCCESSFUL',
    ( actual = instance_in_test.result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "A test with a failure"
  instance_in_test = Test.new 'test1'
  instance_in_test.append_result_of Assertion::Positive.new( 1, :==, [1] )
  instance_in_test.append_result_of Assertion::Positive.new( '', :empty? )
  instance_in_test.append_result_of Assertion::Positive.new( 'a', :empty? )
  failure = "test1:\n" \
    'Assertion failed.' "\n" \
    'The expression "a".empty?() returned false!' "\n"
  MetaTest.test( 'it has one detailed result message',
    ( actual = instance_in_test.result_messages ) == ( expected = [failure] ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its result is FAILED',
    ( actual = instance_in_test.result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "A test with two failures"
  instance_in_test = Test.new 'test2'
  instance_in_test.append_result_of Assertion::Positive.new( 'foo', :==, ['bar'] )
  instance_in_test.append_result_of Assertion::Positive.new( nil, :nil? )
  instance_in_test.append_result_of Assertion::Positive.new( 0, :>=, [1] )
  failure1 = "test2:\n" \
    'Assertion failed.' "\n" \
    'The expression "foo".==("bar") returned false!' "\n"
  failure2 = "test2:\n" \
    'Assertion failed.' "\n" \
    'The expression 0.>=(1) returned false!' "\n"
  MetaTest.test( 'it has two detailed result messages',
    ( actual = instance_in_test.result_messages ) == ( expected = [failure1, failure2] ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its result is FAILED',
    ( actual = instance_in_test.result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
