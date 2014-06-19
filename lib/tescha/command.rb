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
  include Tescha

  project_root = File.join File.dirname(__FILE__), '../..'
  tescha_command = "ruby #{File.expand_path File.join(project_root, 'bin/tescha')}"
  fixtures_directory = File.join(project_root, 'test/tescha/command/fixtures')
  Dir.chdir fixtures_directory do
    puts "Given no argument"
    MetaTest.test('it should be executable and print out nothing.',
      system(tescha_command),
      'Actually something happened. see the error message'
    )

    puts "Given file names"
    expected = [
      "Test Ruby file 1: true",
      "Test Ruby file 2: true",
      "Test Ruby file 3: true",
    ]
    MetaTest.test( 'it executes the given files making Tescha.ready? return true.',
      ( (actual = `#{tescha_command} test?.rb`.lines.map(&:chomp).sort!) == expected.sort! ),
      "The expected value: #{expected.inspect}\n" \
      "The actual value:   #{actual.inspect}"
    )

  end
end
