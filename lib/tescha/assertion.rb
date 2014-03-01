module Tescha
  class Assertion

    def initialize object, method_name, args = []
      @object = object
      @method_name = method_name
      @args = args

      @result = evaluate( object.__send__ method_name, *args )

      if @result == OK
      end
    end

    def evaluate expression
    end

    def to_s
      @result_message
    end

  end
end
