module Moon
  module Logfmt
    # Identity Formatter, this was created to interact with the stdlib
    # Logger::Formatter
    class Formatter
      # @return [String] message
      def call(severity, time, progname, msg)
        msg
      end

      # Returns the default instance of the formatter
      #
      # @return [Formatter]
      def self.default
        @default ||= new
      end
    end

    # Logfmt's actual formatter, this takes a key and a value and produces
    # a string
    class KeyValueFormatter
      # Default KEY=VALUE formatter
      #
      # @param [String] key
      # @param [String] value
      # @return [String]
      def call(key, value)
        "#{key}=#{value}"
      end

      # Returns the default instance of the key value formatter
      #
      # @return [KeyValueFormatter]
      def self.default
        @default ||= new
      end
    end
  end
end
