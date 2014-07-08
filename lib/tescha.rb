require "tescha/version"
require "tescha/set"

module Tescha
  def self.set test_summary, &block
    Set.new( test_summary, &block )
  end
end

if __FILE__ == $PROGRAM_NAME
  set = Tescha.set "Sample tests" do
    instance_in_test = self

    test "I'm a Tescha::Set, a set of tests." do
      assert instance_in_test, :instance_of?, Tescha::Set
    end

    test "I judge whether the given expression returns true." do
      assert 0, :zero?
      assert_true 0, :zero?
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

    test "I judge whether the given expression returns nil." do
      assert_nil [], :first
    end

    test "I can judge a method call with several arguments." do
      assert 1, :between?, -1, 2
    end

    subset "in a subset" do
      test "I'm just same as the Tescha::Set instance above." do
        assert self, :eql?, instance_in_test
      end

      test "Of course I can contain several assertions in a subset" do
        assert 0, :zero?
      end

      subset "in a nested subset" do
        test "I can contain nested subset" do
          assert 1, :==, 1
        end
        test "I'm still just same as the Tescha::Set instance above." do
          assert self, :eql?, instance_in_test
        end
      end
    end

  end

  set.run_tests
end
