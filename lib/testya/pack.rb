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
    end
  end
end
