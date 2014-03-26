require 'tescha/test'

class Tescha::Test
  SKIPPED    = :skipped
  SUCCESSFUL = :successful
  FAILED     = :failed

  class ResultSwitch
    attr_reader :state

    def initialize
      @state = INITIAL
    end

    def final_result
      @state.as_result
    end

    def send new_result
      new_state = State.instance_by_result[ new_result ]
      @state = ( new_state > @state ? new_state : @state )
    end

    class State
      include Comparable

      attr_reader :as_result, :weight
      protected :weight

      def self.instance_by_result
        @instance_by_result ||= {}
      end

      def initialize as_result, weight
        @as_result = as_result
        @weight = weight

        self.class.instance_by_result[ as_result ] = self
      end

      [:<=>, :<, :>, :==].each do|operator|
        class_eval %Q{
          def #{operator} other
            @weight #{operator} other.weight
          end
        }
      end

    end

    INITIAL    = State.new SKIPPED,    0
    SUCCESSFUL = State.new SUCCESSFUL, 1
    FAILED     = State.new FAILED,     2
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  include Tescha

  puts 'When initialized'
  instance_in_test = Test::ResultSwitch.new
  MetaTest.test( 'its state is initial',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::INITIAL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is skipped',
    ( actual = instance_in_test.final_result ) == ( expected = Test::SKIPPED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  puts

  puts 'Given successful'
  instance_in_test.send Test::SUCCESSFUL
  MetaTest.test( 'its state is successful',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is successful',
    ( actual = instance_in_test.final_result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

  puts 'Then given failed'
  instance_in_test.send Test::FAILED
  MetaTest.test( 'its state is failed',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is failed',
    ( actual = instance_in_test.final_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  puts

  puts 'Then given failed again'
  instance_in_test.send Test::FAILED
  MetaTest.test( 'its state is failed',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is failed',
    ( actual = instance_in_test.final_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  puts

  puts 'Then given successful again'
  instance_in_test.send Test::FAILED
  MetaTest.test( 'its state is failed',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is failed',
    ( actual = instance_in_test.final_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  puts

  puts '-------------------------------------------'
  puts 'Given successful twice after initialized'
  instance_in_test = Test::ResultSwitch.new
  instance_in_test.send Test::SUCCESSFUL
  instance_in_test.send Test::SUCCESSFUL
  MetaTest.test( 'its state is successful',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is successful',
    ( actual = instance_in_test.final_result ) == ( expected = Test::SUCCESSFUL ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  puts

  puts 'Then given failed'
  instance_in_test.send Test::FAILED
  MetaTest.test( 'its state is failed',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is failed',
    ( actual = instance_in_test.final_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  puts 

  puts '-------------------------------------------'
  puts 'Given failed after initialized'
  instance_in_test = Test::ResultSwitch.new
  instance_in_test.send Test::FAILED
  MetaTest.test( 'its state is failed',
    ( actual = instance_in_test.state ) == ( expected = Test::ResultSwitch::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
  MetaTest.test( 'its final result is failed',
    ( actual = instance_in_test.final_result ) == ( expected = Test::FAILED ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )

end
