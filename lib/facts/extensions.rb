# This will load Puppet facts, and is SHAMELESSLY stolen
# wholesale from the Facter codebase

class Facts
  module Extensions
    def self.load_puppet
      require 'puppet'
      Puppet.parse_config

      # If you've set 'vardir' but not 'libdir' in your
      # puppet.conf, then the hook to add libdir to $: won't
      # get triggered. This makes sure that it's setup correctly.
      $:.push Puppet[:libdir] unless $:.include? Puppet[:libdir]
      $:.uniq!
    rescue LoadError => detail
      $stderr.puts "Could not load Puppet: #{detail}"
    end
  end
end
