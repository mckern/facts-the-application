require 'facter'
require 'multi_json'
require 'csv'

class Envy < Sinatra::Base

  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, '/../views') }

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    redirect '/index.txt'
  end

  ['/', '/index.txt', '/index.tsv'].each do |path|
    get path do
      @facts = Facter.to_hash
      @facts.map { |k, v| "#{k}\t#{v}\n" }
    end
  end

  get '/index.csv' do
    @facts = Facter.to_hash
    @facts.map { |fact| fact.to_csv }
  end

  get '/index.json' do
    @facts = Facter.to_hash
    MultiJson.dump(@facts, :pretty => true)
  end

  get %r{\A/index\.(yaml|yml)\z} do
    @facts = Facter.to_hash
    YAML.dump @facts
  end
end
