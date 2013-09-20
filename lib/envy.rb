require 'facter'
require 'multi_json'
require 'csv'

class Envy < Sinatra::Base
  set :root, APP_ROOT

  set :logging, true

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    enable :dump_errors, :raise_errors
  end

  # Define a helper to ensure that facts are fresh
  helpers do
    def get_facts
      Facter.reset
      facts = Facter.to_hash
      FILTERS.each { |filter| facts.delete(filter.strip) }
      return facts
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
    content_type 'application/json'

    @facts = get_facts
    MultiJson.dump(@facts, :pretty => true)
  end

  get %r{\A/index\.(yaml|yml)\z} do
    content_type 'application/x-yaml'

    @facts = get_facts
    YAML.dump @facts
  end
end
