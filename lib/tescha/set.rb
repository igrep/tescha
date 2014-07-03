require 'tescha/readiness'
require 'tescha/result_lister'
require 'tescha/test'
require 'tescha/assertion/positive'
require 'tescha/assertion/negative'

module Tescha
  class Set
    def initialize description, &block
      @description = description
      @test_block = block
      @result_lister = Tescha::ResultLister.new
    end
    def run_tests opts = {}
      run_tests! opts.dup
    end
    def run_tests! opts = {}
      @output = opts.delete(:output) || $stdout

      self.instance_eval( &@test_block )
      @result_lister.result_messages.each do|message|
        @output.write message
      end
      @result_lister
    end

    def test description, &block
      @current_test = Tescha::Test.new description
      block.call
      @result_lister.append_test @current_test
      @output.write @result_lister.last_result_sign_in_progress
    ensure
      @current_test = nil
    end

    def assert object, method, *args
      @current_test.append_result_of Tescha::Assertion::Positive.new(object, method, args)
    end

    def assert_not object, method, *args
      @current_test.append_result_of Tescha::Assertion::Negative.new(object, method, args)
    end

  end
end

if Tescha.ready? || __FILE__ == $PROGRAM_NAME
  require 'stringio'
  require 'tescha/meta_test'
  include Tescha

  instance_in_test = Tescha::Set.new 'An empty test set' do
  end

  puts "\n---------------------------#run_tests"
  MetaTest.test(
    "returns a Tescha::ResultLister",
    ( actual = instance_in_test.run_tests ).instance_of?( ResultLister ),
    "#{actual.inspect} is not a Tescha::ResultLister"
  )

  puts "\n---------------------------#initialize"
  set = Tescha::Set.new "test set to test its test block's context" do
    MetaTest.test(
      "the given block is evaluated in the context of the Tescha::Set instance",
      self.instance_of?( Tescha::Set ),
      "#{self.inspect} is not a Tescha::Set"
    )
  end
  set.run_tests(output: StringIO.new) 

  MetaTest.test(
    "outside the block is NOT evaluated in the context of the Tescha::Set instance",
    ( self.to_s == 'main' ),
    "#{self.inspect} is not main object"
  )

  puts "\n---------------------------#test"

  instance_in_test = Tescha::Set.new 'A test set with an empty test' do
    test 'An empty test' do
    end
  end

end
