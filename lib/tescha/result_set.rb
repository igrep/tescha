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
  require 'tescha/meta_test'

  puts 'An empty result set'
  instance_in_test = Tescha::ResultSet.new( [] )

  Tescha::MetaTest.test(
    "prints only the count of examples and failures.",
    ( actual = instance_in_test.to_s ) == ( expected = "0 examples, 0 failures." ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
  )
end
