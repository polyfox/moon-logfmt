module Moon
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

    # Interface for the stdlib Logger class
    module StdlibLoggable
      include Severity

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
    end
  end
end
