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
  MetaTest.test( 'its result is SUCCESSFUL',
    ( actual = instance_in_test.result ) == ( expected = Assertion::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning a truthy value"
  instance_in_test = Assertion.new ['a'], :first
  MetaTest.test( 'its result is SUCCESSFUL',
    ( actual = instance_in_test.result ) == ( expected = Assertion::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning false"
  instance_in_test = Assertion.new :a, :==, :b
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts "given a expression returning nil"
  instance_in_test = Assertion.new {}, :[], :non_exisitng_key
  MetaTest.test( 'its result is failed',
    ( actual = instance_in_test.result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
