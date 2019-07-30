require 'csv' if ENV['SLOW_FACTER_PLEASE']
require 'json'

class Facts < Sinatra::Base
  set :root, APP_ROOT
  enable :logging

  # Make development a little bit chatier
  configure :development do
    enable :dump_errors, :raise_errors
  end

  # Load Facter
  require 'facts/extensions/facter'

  # Add Puppet libdir to $load_path if this env. variable
  # is configured; this adds access to any facts distributed
  # with/by Puppet
  if ENV['USE_PUPPET']
    require 'facts/extensions'
    Facts::Extensions.load_puppet
  end

  # Define a helper to ensure that facts are fresh
  # and purge filtered facts from display
  helpers do
    def load_facts
      Facter.reset
      # Take a hash (which is wildly ordered), sort it (which returns an array),
      # and then turn it back into a hash. Wheeeeeee, Ruby.
      Hash[Facter.to_hash.sort].delete_if { |key| FILTERS.include? key }
    end
  end

  not_found do
    redirect '/'
  end

  ['/', '/index.json'].each do |path|
    get path do
      content_type "application/json;charset=#{settings.default_encoding}"
      JSON.pretty_generate load_facts
    end
  end

  get %r{/index\.(yaml|yml)} do
    content_type "text/x-yaml;charset=#{settings.default_encoding}"
    YAML.dump load_facts
  end

  # native facter (facter 3+) uses structured facts, which do not
  # easily flatten into two-dimensional data structures.
  if ENV['SLOW_FACTER_PLEASE']
    get '/index.csv' do
      content_type "text/csv;charset=#{settings.default_encoding}"
      load_facts.map(&:to_csv)
    end

    get %r{/index\.(txt|tsv)} do
      content_type "text/tab-separated-values;charset=#{settings.default_encoding}"
      load_facts.map { |row| row.to_csv(col_sep: "\t") }
    end
  end
end
