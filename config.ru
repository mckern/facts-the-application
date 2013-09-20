#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

# these have to be set before we include the bulk of this app
#   :environment will inherit this automatically if it's undefined
#   :root will be fed APP_ROOT
ENV['RACK_ENV'] ||= 'development'
ENV['APP_ROOT'] = File.expand_path(File.dirname(__FILE__))

# Load the rest of the application
require './lib/envy'

# Run envy
run Envy.new
