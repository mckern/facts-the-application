#!/usr/bin/env ruby
# frozen_string_literal: true

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.join(APP_ROOT, 'lib')).uniq!

require 'optparse'
require 'bundler/setup'
require 'facts'

if ARGV.any?
  begin
    OptionParser.new do |opts|
      opts.separator("\noptions:")
      opts.on('-p', '--port port', 'set the port (default is 4567)') do |val|
        Facts.set :port, Integer(val)
      end

      opts.on('-b', '--bind addr', 'set the host (default is localhost)') do |val|
        Facts.set :bind, val
      end

      opts.on('-e', '--environment env', 'set the environment (default is development)') do |val|
        Facts.set :environment, val.to_sym
      end

      opts.on_tail('-h', '--help', 'Show this message') do
        puts "#{opts}\n"
        puts <<~ENVVARS
          envrironment variables:
              DEBUG:               set to any value to print debug messages to stderr.
              EXPIRY:              number of seconds to cache Facter data for
              FILTER:              comma delimited list of keys to exclude from output
              FACTERDIR:           path to Facter 'lib' directory
              SLOW_FACTER_PLEASE:  use pure Ruby Facter instead of Native Facter
                                   (Ruby Facter does not have support for structured facts)
        ENVVARS
        exit
      end
    end.parse!(ARGV.dup)
  rescue OptionParser::MissingArgument => msg
    abort "ERROR: #{msg}"
  end
end

begin
  # Load Facter at the last possible moment, because it may throw
  # a LoadError if it's not available and things like `--help` should
  # still work without it
  require 'facts/extensions/facter'

  Facts.run!
rescue LoadError => msg
  abort "ERROR: #{msg}"
end
