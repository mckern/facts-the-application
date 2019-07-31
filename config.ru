#!/usr/bin/env ruby

APP_ROOT = __dir__
$LOAD_PATH.unshift(File.join(APP_ROOT, 'lib')).uniq!

require 'rubygems'
require 'bundler/setup'
require 'facts'

begin
  # Load Facter at the last possible moment, because it may throw
  # a LoadError if it's not available and things like `--help` should
  # still work without it
  require 'facts/extensions/facter'

  run Facts
rescue LoadError => msg
  abort "ERROR: #{msg}"
end
