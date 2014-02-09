module Testya
  class Pack
    def initialize test_summary, &block
      @test_summary = test_summary
      @description_block = block
    end
    def run_tests
      # Fake implementation
    end
  end
end
