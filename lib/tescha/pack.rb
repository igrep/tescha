require 'tescha/result_set'

module Tescha
  class Pack
    def initialize description, &block
      @description = description
      @test_block = block
      @test_results = []
    end
    def run_tests
      puts self.judge_results.summary
    end
    def judge_results
      self.instance_eval( &@test_block )
      Tescha::ResultSet.new
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'

  instance_in_test = Tescha::Pack.new 'An empty test pack' do
  end

  puts "\n---------------------------#judge_results"
  Tescha::MetaTest.test(
    "returns a Tescha::ResultSet",
    ( actual = instance_in_test.judge_results ).instance_of?( expected = Tescha::ResultSet ),
    "#{actual.inspect} is not a #{expected}"
  )

  puts "\n---------------------------#initialize"
  pack = Tescha::Pack.new "test pack to test its test block's context" do
    Tescha::MetaTest.test(
      "the given block is evaluated in the context of the Tescha::Pack instance",
      self.instance_of?( Tescha::Pack ),
      "#{self.inspect} is not a Tescha::Pack"
    )
  end
  pack.judge_results

  Tescha::MetaTest.test(
    "outside the block is NOT evaluated in the context of the Tescha::Pack instance",
    ( self.to_s == 'main' ),
    "#{self.inspect} is not main object"
  )
end
