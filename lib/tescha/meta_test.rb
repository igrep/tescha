module Tescha
  MetaTest = Module.new
  class << MetaTest
    def test description, boolean_expression, on_failure
      puts description
      if boolean_expression
        puts 'OK'
      else
        fail "Assertion failed.\n#{on_failure}"
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Tescha::MetaTest.test(
    "Some test case to pass",
    true, 
    "This string must not be used."
  )
  Tescha::MetaTest.test(
    "Some test case to fail",
    ( actual = 1 ) == ( expected = 2 ), 
    "The expected value is: #{expected.inspect}\n" \
      "The actual value is:   #{actual.inspect}"
  )
end
