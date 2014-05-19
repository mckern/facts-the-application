#!/usr/bin/env ruby

APP_ROOT = File.expand_path(File.dirname(__FILE__))
FILTERS = %w[
  ec2_public_keys_0_openssh_key
  ec2_userdata
  path
  sshdsakey
  sshecdsakey
  sshfp_dsa
  sshfp_ecdsa
  sshfp_rsa
  sshrsakey
]

require 'rubygems'
require 'sinatra'
require 'bundler/setup'

Bundler.require :default
Bundler.require :puppet if ENV['USE_PUPPET']

# Load the rest of the application
require './lib/facts'

# Run Facts
run Facts.new
