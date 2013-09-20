require 'facter'
require 'multi_json'
require 'csv'

class Facts < Sinatra::Base
  set :root, APP_ROOT
  enable :logging

  # Make development a little bit chatier
  configure :development do
    enable :dump_errors, :raise_errors
  end

  # Add Puppet libdir to $load_path if this env. variable
  # is configured; this adds access to any facts distributed
  # with/by Puppet
  if ENV['USE_PUPPET']
    Bundler.require :puppet

    require_relative 'Facts/extensions'
    Facts::Extensions.load_puppet
  end

  # Define a helper to ensure that facts are fresh
  # and purge filtered facts from display
  helpers do
    def get_facts
      Facter.reset
      facts = Facter.to_hash
      facts.delete_if { |key| FILTERS.include? key }
    end
  end

  not_found do
    redirect '/index.txt'
  end

  ['/', '/index.txt', '/index.tsv'].each do |path|
    get path do
      content_type ' text/plain'

      @facts = get_facts
      @facts.map { |k, v| "#{k}\t#{v}\n" }
    end
  end

  get '/index.csv' do
    content_type 'text/csv'

    @facts = get_facts
    @facts.map { |fact| fact.to_csv }
  end

  get '/index.json' do
    content_type 'application/json;charset=utf-8'

    @facts = get_facts
    MultiJson.dump(@facts, :pretty => true)
  end

  get %r{\A/index\.(yaml|yml)\z} do
    content_type 'text/x-yaml;charset=utf-8'

    @facts = get_facts
    YAML.dump @facts
  end
end
