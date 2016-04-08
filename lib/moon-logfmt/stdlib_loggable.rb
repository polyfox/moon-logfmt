require 'moon-logfmt/severity'

module Moon
  module Logfmt
    # Interface for the stdlib Logger class
    module StdlibLoggable
      include Severity

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

      # @!group std Logger interface

      # Adds a new logger message
      #
      # @param [Severity] severity
      # @param [String, nil] message
      # @param [String, nil] progname
      # @yieldreturn [String] message
      def add(severity, message = nil, progname = nil, &block)
        return if severity < @level
        message = message || (block && block.call)
        msg = message || progname
        data = {}
        data[:progname] = progname if progname && message
        data[:level] = severity_to_symbol(severity)
        msg.is_a?(Hash) ? data.merge!(msg) : data.store(:msg, msg)
        write data
      end
      alias :log :add

      # Logs a message
      #
      # @overload info(data)
      #   @param [Hash] data - data to log
      # @overload info(message)
      #   @param [String] message - message to log
      # @overload info(progname, &block)
      #   @param [String] progname - program name
      #   @yieldreturn [String] message - message to log
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
