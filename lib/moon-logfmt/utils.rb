require 'moon-logfmt/severity'

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

    # Determines what the loglevel should be from the given object
    #
    # @param [Object] object
    # @return [Integer] loglevel
    def self.determine_loglevel_from_object(object)
      return object if object.is_a?(Integer)
      case object.to_s.upcase
      when 'DEBUG'   then Moon::Logfmt::Severity::DEBUG
      when 'INFO'    then Moon::Logfmt::Severity::INFO
      when 'WARN'    then Moon::Logfmt::Severity::WARN
      when 'ERROR'   then Moon::Logfmt::Severity::ERROR
      when 'FATAL'   then Moon::Logfmt::Severity::FATAL
      when 'UNKNOWN' then Moon::Logfmt::Severity::UNKNOWN
      else
        raise ArgumentError, "unknown log level #{object}"
      end
    end

    # (see Moon::Logfmt::Logger#initialize)
    def self.new(*args, &block)
      Moon::Logfmt::Logger.new(*args, &block)
    end
  end
end
