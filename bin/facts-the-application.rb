#!/usr/bin/env ruby
# frozen_string_literal: true

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.join(APP_ROOT, 'lib')).uniq!

require 'optparse'
require 'bundler/setup'
require 'facts'

if ARGV.any?
  OptionParser.new do |op|
    op.on('-p', '--port port', 'set the port (default is 4567)') do |val|
      Facts.set :port, Integer(val)
    end

    op.on('-b', '--bind addr', 'set the host (default is localhost)') do |val|
      Facts.set :bind, val
    end

    op.on('-e', '--environment env', 'set the environment (default is development)') do |val|
      Facts.set :environment, val.to_sym
    end
  end.parse!(ARGV.dup)
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
