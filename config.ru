#!/usr/bin/env ruby

APP_ROOT = File.expand_path(File.dirname(__FILE__))
FILTERS = %w[
  ec2_public_keys_0_openssh_key
  ec2_userdata
  sshdsakey
  sshecdsakey
  sshfp_dsa
  sshfp_ecdsa
  sshfp_rsa
  sshrsakey
]

require 'rubygems'
require 'sinatra'
require 'bundler'

Bundler.require :default

# Load the rest of the application
require './lib/facts'

# Run Facts
run Facts.new
