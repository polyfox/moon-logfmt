require 'moon-logfmt/logger'
require 'moon-logfmt/null_logger'

module Moon
  # Implementation of logfmt for Moon
  module Logfmt
    # Regular expression used for checking strings that may need escaping.
    # This regular expression will validate true if the string doesn't need
    # escaping.
    UNESCAPED_STRING = /\A[\w\.\-\+\%\_\,\:\;\/]*\z/i

    # Escapes the context values and yields the result.
    #
    # @param [Hash<[String, Symbol], String>] data
    # @yieldparam [String] key
    # @yieldparam [String] value
    def self.escape_context_data(data)
      return to_enum :escape_context_data, data unless block_given?
      data.each_pair do |key, value|
        case value
        when Array
          value = value.join(',')
        else
          value = value.to_s
        end
        value = value.dump unless value =~ UNESCAPED_STRING
        yield key.to_s, value
      end
    end

    # (see Moon::Logfmt::Logger#initialize)
    def self.new(*args, &block)
      Moon::Logfmt::Logger.new(*args, &block)
    end
  end
end
