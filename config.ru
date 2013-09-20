#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

# these have to be set before we include the bulk of this app
#   :environment will inherit this automatically if it's undefined
#   :root will be fed APP_ROOT
#   FILTERS contains facts that won't be reported
ENV['RACK_ENV'] ||= 'development'
APP_ROOT = File.expand_path(File.dirname(__FILE__))
FILTERS = %w[
  ec2_public_keys_0_openssh_key
  ec2_userdata
  sshdsakey
  sshfp_dsa
  sshfp_rsa
  sshrsakey
]

# Load the rest of the application
require './lib/envy'

# Run envy
run Envy.new
