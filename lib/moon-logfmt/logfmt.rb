require 'moon-null_io/null_io'

module Moon
  # Implementation of logfmt for Moon
  module Logfmt
    # Logging severity.
    module Severity
      # Low-level information, mostly for developers.
      DEBUG = 0
      # Generic (useful) information about system operation.
      INFO = 1
      # A warning.
      WARN = 2
      # A handleable error condition.
      ERROR = 3
      # An unhandleable error that results in a program crash.
      FATAL = 4
      # An unknown message that should always be logged.
      UNKNOWN = 5
    end

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

    FORMATTER = ->(key, value) { "#{key}=#{value}" }

    # Basic Logger class for Logfmt writing
    # The main functions are #write and #new
    # #new will copy the current logger and append its context data
    class Logger
      include Severity

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
      end

      # @param [Logfmt::Logger] org
      # @return [self]
      def initialize_copy(org)
        @io = org.io
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

      # @!group std Logger interface
      # @param [Severity] severity
      # @param [String, nil] message
      # @param [String, nil] progname
      # @yieldreturn [String] message
      def add(severity, message = nil, progname = nil, &block)
        message = message || (block && block.call)
        msg = message || progname
        data = {}
        data[:progname] = progname if progname && message
        data[case severity
          when DEBUG then :debug
          when ERROR then :error
          when FATAL then :fatal
          when INFO then :msg
          when UNKNOWN then :msg
          when WARN then :warn
          end] = msg
        write data
      end
      alias :log :add

      # Logs a message
      #
      # @overload info(message)
      #   @param [String] message
      # @overload info(progname, &block)
      #   @param [String] progname
      #   @yieldreturn [String] message
      def info(progname = nil, &block)
        add(INFO, nil, progname, &block)
      end

      # See {#info} for more information.
      # (see #info)
      def debug(progname = nil, &block)
        add(DEBUG, nil, progname, &block)
      end

      # See {#info} for more information.
      # (see #info)
      def error(progname = nil, &block)
        add(ERROR, nil, progname, &block)
      end

      # See {#info} for more information.
      # (see #info)
      def fatal(progname = nil, &block)
        add(FATAL, nil, progname, &block)
      end

      # See {#info} for more information.
      # (see #info)
      def unknown(progname = nil, &block)
        add(UNKNOWN, nil, progname, &block)
      end

      # See {#info} for more information.
      # (see #info)
      def warn(progname = nil, &block)
        add(WARN, nil, progname, &block)
      end
      # @!endgroup

      # Creates a new context by forking the current logger
      #
      # @param [Hash<[Symbol, String], String>] data
      def new(data)
        dup.tap { |l| l.context.merge!(data) }
      end
    end

    NullLogger = Logger.new
    NullLogger.io = NullIO::OUT
  end
end
