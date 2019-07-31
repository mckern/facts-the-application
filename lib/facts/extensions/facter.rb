# frozen_string_literal: true

class Facts
  module Extensions
    module Facter
      # First accommodate Classic Facter
      require 'facter' if ENV['SLOW_FACTER_PLEASE']

      # Then, failing that, attempt to load Native Facter
      unless Object.const_defined? 'Facter'
        begin
          require "#{ENV['FACTERDIR'] || '/opt/puppetlabs/puppet'}/lib/libfacter.so"
        rescue LoadError
          raise LoadError, 'libfacter was not found. Please make sure it was installed to the expected location.'
        end
      end
    end
  end
end
