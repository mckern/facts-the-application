# frozen_string_literal: true

require 'csv' if ENV['SLOW_FACTER_PLEASE']
require 'json'
require 'singleton'
require 'yaml'
require 'sinatra/base'

class Facts < Sinatra::Base
  set :root, APP_ROOT
  set :quiet, true
  set :lock, true

  enable :logging

  # Make development a little bit chatier
  configure :development do
    enable :dump_errors, :raise_errors
  end

  # Define a helper to ensure that facts are fresh
  # and purge filtered facts from display
  helpers do
    def facts
      Facts::Cache.instance.facts
    end
  end

  not_found do
    redirect '/'
  end

  ['/', '/index.json'].each do |path|
    get path do
      content_type "application/json;charset=#{settings.default_encoding}"
      JSON.pretty_generate facts
    end
  end

  get %r{/index\.(yaml|yml)} do
    content_type "text/x-yaml;charset=#{settings.default_encoding}"
    YAML.dump facts
  end

  # native facter (facter 3+) uses structured facts, which do not
  # easily flatten into two-dimensional data structures.
  if ENV['SLOW_FACTER_PLEASE']
    get '/index.csv' do
      content_type "text/csv;charset=#{settings.default_encoding}"
      facts.map(&:to_csv)
    end

    get %r{/index\.(txt|tsv)} do
      content_type "text/tab-separated-values;charset=#{settings.default_encoding}"
      facts.map { |row| row.to_csv(col_sep: "\t") }
    end
  end

  class Cache
    include Singleton

    # These are Facter keys/facts that should not be displayed
    # by Facts-The-Application.
    DEFAULT_FILTERS = %w[
      ec2_public_keys_0_openssh_key
      ec2_userdata
      path
      sshdsakey
      sshecdsakey
      sshfp_dsa
      sshfp_ecdsa
      sshfp_rsa
      sshrsakey
    ].freeze
    FILTERS = ENV['FILTER'] ? ENV['FILTER'].split(',').map(&:strip) : DEFAULT_FILTERS

    def initialize
      update!
    end

    def facts
      return @facts unless expired?

      warn 'cache age expired, refreshing fact cache' if ENV['DEBUG']
      update!
      @facts
    end

    def expired?
      warn "cache time: #{@facts['cache_time']}" if ENV['DEBUG']
      return true unless @facts['cache_time']

      cache_time = Time.parse(@facts['cache_time'])
      warn "cache age: #{Time.now - cache_time}" if ENV['DEBUG']
      (Time.now - cache_time) > 60
    end

    def update!
      Facter.reset

      # Take a hash (which is wildly ordered), sort it (which returns an array),
      # and then turn it back into a hash. Wheeeeeee, Ruby.
      f = Facter.to_hash
      f['cache_time'] = Time.now.to_s
      @facts = Hash[f.sort].delete_if { |key| FILTERS.include? key }
      warn "updated facts_cache; (#{@facts.keys.size} keys), new time #{@facts['cache_time']}" if ENV['DEBUG']
    end
  end
end
