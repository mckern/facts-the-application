class Facts
  module Extensions
    module Facter
      # First accommodate Classic Facter
      require 'facter' if ENV['SLOW_FACTER_PLEASE']

      # Then, failing that, attempt to load Native Facter
      unless Object.const_defined? 'Facter'
        begin
          require "#{ENV['FACTERDIR'] || '/usr'}/lib/libfacter.so"
        rescue LoadError
          raise LoadError.new('libfacter was not found. Please make sure it was installed to the expected location.')
        end
      end
    end
  end
end
