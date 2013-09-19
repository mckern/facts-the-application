#!/usr/bin/env ruby

# Gem no longer appends '.' to the search path, so we're being explicit
require 'rubygems'

# Does this work with slimgems? Nope.
# Does this work with any Gem version lower than 1.8? Good question.
# Either way, it's going to fail if we're using an old rubygem version,
# BECAUSE I SAID SO.
# raise "Your version of rubygems (#{Gem::VERSION}) is too old" if Gem::VERSION < '1.8.0'

require 'sinatra'
require 'sinatra/reloader'
require './lib/envy'

ENV['RACK_ENV'] ||= 'development'

enable :logging

if ENV['RACK_ENV'].eql? 'development'
  enable :dump_errors, :raise_errors
end


APP_ROOT = File.expand_path(File.dirname(__FILE__))

run Envy.new
