require 'optparse'
require 'shellwords'

module Tescha
  module Command
    class << self
      def execute argv
        require 'tescha/go'

        parse_argv! argv
        argv.each do|test_file_path|
          load test_file_path
        end
      end

      def parse_argv! argv
        parser = OptionParser.new
        options = {}

        parser.on '-w', '--[no-]warnings', 'Enable Ruby\'s warnings.' do|v|
          $VERBOSE = v
          options[:warnings] = v
        end

        parser.parse! argv
        options
      end

    end

  end
end
