require 'testya/result_set'

module Testya
  class Pack
    def initialize test_summary, &block
      @test_summary = test_summary
      @description_block = block
    end
    def run_tests
      puts self.judge_results
    end
    def judge_results
      # Fake implementation
      Testya::ResultSet.new
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  this_file = File.readlines( __FILE__ )

  instance_in_test = Testya::Pack.new 'description' do
  end

  assertion_line = this_file[ __LINE__ ].sub( /if/, ''.freeze ).strip
  if instance_in_test.judge_results.instance_of? Testya::ResultSet
    puts 'OK'
  else
    fail "Assertion failed: '#{assertion_line}'"
  end
end
