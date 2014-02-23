require "tescha/version"
require "tescha/pack"

module Tescha
  def self.pack test_summary, &block
    Pack.new( test_summary, &block )
  end
end

if __FILE__ == $PROGRAM_NAME
  pack = Tescha.pack "Sample tests" do
    instance_in_test = self

    test "I'm a Tescha::Pack, a package of tests." do
      assert instance_in_test, :instance_of?, Tescha::Pack
    end

    test "I judge whether the given expression returns true." do
      assert 0, :zero?
    end

    test "I judge whether the given expression returns a truthy." do
      assert 1, :nonzero? # 1.nonzero? returns 1, not true.
    end

    test "I judge whether the given expression returns false" do
      assert_not 1, :zero?
    end

    test "I judge whether the given expression returns a falsy." do
      assert_not [], :first
    end

    test "I can judge a method call with several arguments." do
      assert 1, :between?, -1, 2
    end

    subpack "in a sub package" do
      test "I'm just same as the Tescha::Pack instance above." do
        assert self, :eql?, instance_in_test
      end

      test "Of course I can contain several assertions in a sub pack" do
        assert 0, :zero?
      end

      subpack "in a nested sub package" do
        test "I can contain nested sub packages" do
          assert 1, :==, 1
        end
        test "I'm still just same as the Tescha::Pack instance above." do
          assert self, :eql?, instance_in_test
        end
      end
    end

  end

  pack.run_tests
end
