# Define a default source for gems
source 'https://rubygems.org/'

# declare the sinatra dependency
gem 'sinatra', '~> 1.4.0'
gem 'multi_json', '~> 1.11.0'

# Facter 3 is a C++ program, and it includes a Facter library.
# The bindings for this are vendored into Facts-The-Application
# now, so Facter-the-gem is no longer a strict dependency.
# If you're not using native Facter, then including
# the 'facter' bundle group should fix you right up.
group :facter do
  gem 'facter', '< 3.0.0'
end

# Use the 'puppet' bundle group if you'd like access
# to facts that are distributed with/by Puppet.
group :puppet do
  gem 'puppet'
end

group :test do
  gem 'rspec'
end

group :puma do
  gem 'puma'
end
