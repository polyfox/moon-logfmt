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
      include Severity

      # The default datetime string format
      # @return [String]
      DEFAULT_DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%S%Z'.freeze

      # The underlaying IO to write to, the default is STDOUT
      # @return [IO, #puts]
      attr_accessor :io

      # A function which takes a key and value string and produces a string
      # @return [Proc]
      attr_accessor :key_value_formatter

      # A function which takes the final context string and formats it
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
        @formatter = Formatter.default
        @key_value_formatter = KeyValueFormatter.default
        @context = data
        @timestamp = true
        @level = Moon::Logfmt::Severity::DEBUG
        @datetime_format = DEFAULT_DATETIME_FORMAT
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
        @key_value_formatter = org.key_value_formatter
        self
      end

      # @param [Integer] severity
      # @return [Symbol]
      private def severity_to_symbol(severity)
        case severity
        when DEBUG   then :debug
        when INFO    then :info
        when WARN    then :warn
        when ERROR   then :error
        when FATAL   then :fatal
        when UNKNOWN then :unknown
        else
          severity.to_s
        end
      end

      # Adds timestamp information to the provided data
      #
      # @param [Hash<Symbol, Object>] data  to add timestamp to
      # @return [Hash] data given
      private def timestamp_context(data)
        data.tap { |d| d[:now] = Time.now.strftime(@datetime_format) }
      end

      # Formats the provided context data
      #
      # @param [Hash<[String, Symbol], String>] data
      # @return [String]
      private def format_context(severity, time, progname, ctx)
        data = {}
        data[:level] = severity_to_symbol(severity) if severity
        timestamp_context(data) if @timestamp
        data[:progname] = progname if progname
        data.merge!(ctx)
        str = []
        Logfmt.escape_context_data data do |key, value|
          str << @key_value_formatter.call(key, value)
        end
        @formatter.call(severity, time, progname, str.join(' '))
      end

      protected def write_to_logdev(str)
        @io.puts str
      end

      # Writes a new context line to the logdev
      # @param [Integer] severity
      # @param [Time] time
      # @param [String] progname
      # @param [Hash] ctx
      protected def write_context(severity, time, progname, ctx)
        write_to_logdev format_context(severity, time, progname, context.merge(ctx))
      end

      # Writes a new log line
      #
      # @param [Hash<[String, Symbol], String>] data
      def write(data)
        write_context nil, Time.now, nil, data
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
