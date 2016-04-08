require 'moon-logfmt/stdlib_loggable'
require 'moon-logfmt/formatter'
require 'moon-logfmt/utils'

module Moon
  module Logfmt
    # Basic Logger class for Logfmt writing
    # The main functions are #write and #new
    # #new will copy the current logger and append its context data
    class Logger
      include StdlibLoggable

      # The underlaying IO to write to, the default is STDOUT
      # @return [IO, #puts]
      attr_accessor :io

      # A function which takes a key and value string and produces a string
      # @return [Proc]
      attr_accessor :formatter

      # Whether to prepend timestamps to the logs
      # @return [Boolean]
      attr_accessor :timestamp

      # Context related data, this protected, don't even think of using it.
      # @return [Hash<[String, Symbol], String>]
      attr_accessor :context
      protected :context
      protected :context=

      # @param [Hash<[String, Symbol], String>] data
      def initialize(data = {})
        @io = STDOUT
        @formatter = FORMATTER
        @context = data
        @timestamp = true
        @level = Moon::Logfmt::Severity::DEBUG
      end

      attr_reader :level

      # @param [Symbol]
      def level=(lvl)
        @level = Moon::Logfmt.determine_loglevel_from_object(lvl)
      end

      # @param [Logfmt::Logger] org
      # @return [self]
      def initialize_copy(org)
        @io = org.io
        @level = org.level
        @timestamp = org.timestamp
        @context = org.context.dup
        @formatter = org.formatter
        self
      end

      # Formats the provided context data
      #
      # @param [Hash<[String, Symbol], String>] data
      # @return [String]
      private def format_context(data)
        str = []
        Logfmt.escape_context_data data do |key, value|
          str << @formatter.call(key, value)
        end
        str.join(' ')
      end

      # Adds timestamp information to the provided data
      #
      # @param [Hash<Symbol, Object>] data  to add timestamp to
      # @return [Hash] data given
      private def timestamp_context(data)
        t = Time.now
        fmt = '%04d-%02d-%02dT%02d:%02d:%02d%s'
        s = sprintf(fmt, t.year, t.mon, t.day, t.hour, t.min, t.sec, t.zone)
        data[:now] = s
        data
      end

      # Writes a new log line
      #
      # @param [Hash<[String, Symbol], String>] data
      def write(data)
        pre = {}
        timestamp_context(pre) if @timestamp
        @io.puts format_context(pre.merge(context.merge(data)))
      end

      # Creates a new context by forking the current logger
      #
      # @param [Hash<[Symbol, String], String>] data
      def new(data)
        dup.tap { |l| l.context.merge!(data) }
      end
    end
  end
end
