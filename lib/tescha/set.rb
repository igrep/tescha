require 'tescha/result_lister'

module Tescha
  class Set
    def initialize description, &block
      @description = description
      @test_block = block
      @result_lister = Tescha::ResultLister.new
    end
    def run_tests opts
      run_tests! opts.clone
    end
    def run_tests! opts
      output = opts.delete :output
      output.puts self.judge_results.summary
    end
    def judge_results
      self.instance_eval( &@test_block )
      @result_lister
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  include Tescha

  instance_in_test = Tescha::Set.new 'An empty test set' do
  end

  puts "\n---------------------------#judge_results"
  MetaTest.test(
    "returns a Tescha::ResultLister",
    ( actual = instance_in_test.judge_results ).instance_of?( ResultLister ),
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
  set.judge_results

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
