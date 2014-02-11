module Tescha
  class ResultSet
    def initialize results
      @failures = []
      @results = []
    end
    def to_s
      "#{@results.length} examples, #{@failures.length} failures."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  this_file = File.readlines( __FILE__ )

  puts 'An empty result set'
  instance_in_test = Tescha::ResultSet.new( [] )

  assertion_line = this_file[ __LINE__ ].sub( /if/, ''.freeze ).strip
  if ( actual = instance_in_test.to_s ) == ( expected = "0 examples, 0 failures." )
    puts 'OK'
  else
    fail "Assertion failed in '#{assertion_line}'\n" \
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  end
end
