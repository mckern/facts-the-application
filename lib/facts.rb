require 'csv'
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
      facts = Facter.to_hash.sort.to_h
      facts.delete_if { |key| FILTERS.include? key }
    end
  end

  not_found do
    redirect '/'
  end

  ['/', '/index.json'].each do
    get path do
      content_type 'application/json;charset=utf-8'

      @facts = load_facts
      JSON.pretty_generate(@facts)
    end
  end

  get '/index.csv' do
    content_type 'text/csv;charset=utf-8'

    @facts = load_facts
    @facts.map(&:to_csv)
  end

  get %r{\A/index\.(txt|tsv)\z} do
    content_type ' text/plain'

    @facts = load_facts
    @facts.map { |row| row.to_csv(col_sep: "\t") }
  end

  get %r{\A/index\.(yaml|yml)\z} do
    content_type 'text/x-yaml;charset=utf-8'

    @facts = load_facts
    YAML.dump @facts
  end
end
