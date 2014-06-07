require 'tescha/result_lister'

module Tescha
  class Pack
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

  instance_in_test = Pack.new 'An empty test pack' do
  end

  puts "\n---------------------------#judge_results"
  MetaTest.test(
    "returns a Tescha::ResultLister",
    ( actual = instance_in_test.judge_results ).instance_of?( ResultLister ),
    "#{actual.inspect} is not a Tescha::ResultLister"
  )

  puts "\n---------------------------#initialize"
  pack = Pack.new "test pack to test its test block's context" do
    MetaTest.test(
      "the given block is evaluated in the context of the Tescha::Pack instance",
      self.instance_of?( Pack ),
      "#{self.inspect} is not a Tescha::Pack"
    )
  end
  pack.judge_results

  MetaTest.test(
    "outside the block is NOT evaluated in the context of the Tescha::Pack instance",
    ( self.to_s == 'main' ),
    "#{self.inspect} is not main object"
  )

  puts "\n---------------------------#test"

  instance_in_test = Pack.new 'A test pack with an empty test' do
    test 'An empty test' do
    end
  end

end
