require 'singleton'

module Playmo
  class Options
  	include Singleton
    attr_accessor :options_hash

    def set(key, value)
      raise ArgumentError, "Cannot set key as nil!" if key.nil?
      
      @options_hash ||= {}
      @options_hash[key.to_sym] = value
    end

    def get(key)
      @options_hash[key.to_sym]
    end
  end
end