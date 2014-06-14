require 'optparse'
require 'shellwords'

module Tescha
  module Command
    class << self
      def execute argv
        options = parse_argv! argv
        append_rubylib_to ENV
        argv.each do|test_file_path|
          system(
            *(
              options[:ruby_command] +
                options[:ruby_opts] +
                ['-r'.freeze, 'tescha/go'.freeze, '--'.freeze, test_file_path]
            )
          )
        end
      end

      def parse_argv! argv
        parser = OptionParser.new
        options = {}

        options[:ruby_opts] = []
        parser.on '-r RUBY_OPTS', '--ruby-opts=RUBY_OPTS', 'Additional options given to ruby command. Can specify multiple times.' do|v|
          options[:ruby_opts] << Shellwords.split(v)
        end
        parser.on '-w', '--warnings', 'Same as --ruby-opts=-w' do|v|
          options[:ruby_opts] << '-w'
        end

        # FIXME: I'm not sure when to automatically make the default "bundle exec ruby" or "ruby"
        options[:ruby_command] = %w'bundle exec ruby'
        parser.on '-c RUBY_COMMAND', '--ruby-command=RUBY_COMMAND', 'Alternative ruby command (default: "bundle exec ruby"' do|v|
          options[:ruby_command] = Shellwords.split(v)
        end

        parser.parse! argv
        options
      end

      private

        def __dir__
          File.dirname(File.expand_path(__FILE__))
        end unless respond_to? __dir__

        def append_rubylib_to env
          rubylib = 'RUBYLIB'.freeze
          if env[rubylib]
            env[rubylib] += "#{File::PATH_SEPARATOR}#{__dir__}"
          else
            env[rubylib] = __dir__
          end
        end

    end

  end
end
