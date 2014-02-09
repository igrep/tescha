require "testya/version"
require "testya/pack"

module Testya
  def self.pack test_summary, &block
    Pack.new( test_summary, &block )
  end
end

if __FILE__ == $PROGRAM_NAME
  pack = Testya.pack "Sample tests" do
    instance_in_test = self

    assert "I'm a Testya::Pack, a package of tests.",
      instance_in_test, :is_a?, Testya::Pack

    assert "I judge whether the given expression returns true.",
      0, :zero?

    assert "I judge whether the given expression returns a truthy.",
      1, :nonzero? # 1.nonzero? returns 1, not true.

    assert_not "I judge whether the given expression returns false",
      1, :zero?

    assert_not "I judge whether the given expression returns a falsy.",
      [], :first

    assert "I can judge a method call with several arguments.",
      1, :between?, -1, 2

    sub_pack "in a sub package" do
      assert "I'm just same as the Testya::Pack instance above.",
        self, :eql?, instance_in_test

      assert "Of course I can contain several assertions in a sub pack",
        0, :zero?

      sub_pack "in a nested sub package" do
        assert "I can contain nested sub packages",
          1, :==, 1
        assert "I'm still just same as the Testya::Pack instance above.",
          self, :eql?, instance_in_test
      end
    end

  end

  pack.run_tests
end
