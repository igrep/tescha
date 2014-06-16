require 'optparse'
require 'shellwords'

module Tescha
  module Command
    class << self
      def execute argv
        require 'tescha/go'

        parse_argv! argv
        argv.each do|test_file_path|
          load_no_reloading test_file_path
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

      def load_no_reloading path
        require File.expand_path path.sub(/\.rb$/, ''.freeze)
      end

    end

  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  require 'tmpdir'

  Dir.mktmpdir do|dir|
  end
end
