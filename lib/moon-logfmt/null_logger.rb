require 'moon-logfmt/logger'

module Moon
  module Logfmt
    NullLogger = Logger.new
    NullLogger.io = NullIO::OUT
  end
end
