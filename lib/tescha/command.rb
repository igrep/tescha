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

  project_root = File.join File.dirname(__FILE__), '../..'
  tescha_command = File.expand_path File.join(project_root, 'bin/tescha')
  fixtures_directory = File.join(project_root, 'test/tescha/command/fixtures')
  Dir.chdir fixtures_directory do
    p system('ruby', tescha_command) # check if executable
  end
end
