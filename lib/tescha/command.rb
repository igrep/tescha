require 'optparse'
require 'shellwords'
require 'find'

module Tescha
  module Command
    class << self
      def execute argv
        require 'tescha/go'

        parse_argv! argv
        each_file_considering_directories argv do|test_file_path|
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
        # strings in ARGV are often freezed!
        path_thawed = path.dup
        if path_thawed.sub!(/\.rb$/, ''.freeze)
          require File.expand_path path_thawed
        end
      end

      def each_file_considering_directories paths, &block
        paths.each do|path|
          case (ftype = File.ftype path)
          when "directory".freeze
            Find.find path do|path_in_directory|
              case (ftype_in_directory = File.ftype path_in_directory)
              when "directory".freeze
                next
              when "file".freeze, "link".freeze
                block.call path_in_directory
              else
                raise "Unexpected file type: #{ftype_in_directory}"
              end
            end
          when "file".freeze, "link".freeze
            block.call path
          else
            raise "Unexpected file type: #{ftype}"
          end
        end
      end

    end

  end
end

if __FILE__ == $PROGRAM_NAME
  require 'tescha/meta_test'
  require 'pp'
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

    puts "Given file names and directory names"
    expected = [
      "Test Ruby file 1 in directory 1: true",
      "Test Ruby file 2 in directory 1: true",
      "Test Ruby file 3 in directory 1: true",
      "Test Ruby file 1 in nested directory 1 in directory 2: true",
      "Test Ruby file 2 in nested directory 1 in directory 2: true",
      "Test Ruby file 3 in nested directory 1 in directory 2: true",
      "Test Ruby file 1 in nested directory 2 in directory 2: true",
      "Test Ruby file 2 in nested directory 2 in directory 2: true",
      "Test Ruby file 3 in nested directory 2 in directory 2: true",
      "Test Ruby file 1 in directory 2: true",
      "Test Ruby file 2 in directory 2: true",
      "Test Ruby file 3 in directory 2: true",
      "Test Ruby file 1: true",
      "Test Ruby file 2: true",
      "Test Ruby file 3: true",
    ]
    MetaTest.test(
      'it executes the given files and files in the given directoy recursively making Tescha.ready? return true.',
      ( (actual = `#{tescha_command} *`.lines.map(&:chomp).sort!) == expected.sort! ),
      "The expected value: #{expected.pretty_inspect}\n" \
      "The actual value:   #{actual.pretty_inspect}"
    )

  end
end
