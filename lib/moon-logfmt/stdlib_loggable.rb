require 'moon-logfmt/severity'

module Moon
  module Logfmt
    # Interface for the stdlib Logger class
    module StdlibLoggable
      include Severity

      # @!group std Logger interface

      # Adds a new logger message
      #
      # @param [Severity] severity
      # @param [String, nil] message
      # @param [String, nil] progname
      # @yieldreturn [String] message
      def add(severity, message = nil, progname = nil, &block)
        return if severity < @level
        msg = if block_given?
          block.call
        elsif message
          message
        else
          tmp = progname
          progname = nil
          tmp
        end
        data = {}
        msg.is_a?(Hash) ? data.merge!(msg) : data.store(:msg, msg)
        write_context(severity, Time.now, progname, data)
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
