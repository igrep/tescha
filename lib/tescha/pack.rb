require 'tescha/result_set'

module Tescha
  class Pack
    def initialize description, &block
      @description = description
      @test_block = block
    end
    def run_tests
      puts self.judge_results
    end
    def judge_results
      # Fake implementation
      Tescha::ResultSet.new
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'

  instance_in_test = Tescha::Pack.new 'An empty test pack' do
  end

  puts "#judge_results"
  Tescha::MetaTest.test(
    "returns a Tescha::ResultSet",
    ( actual = instance_in_test.judge_results ).instance_of?( expected = Tescha::ResultSet ),
    "#{actual.inspect} is not a #{expected}"
  )
end
