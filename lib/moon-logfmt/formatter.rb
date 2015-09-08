module Moon
  module Logfmt
    # Default KEY=VALUE formatter
    #
    # @param [String] key
    # @param [String] value
    # @return [String]
    FORMATTER = ->(key, value) { "#{key}=#{value}" }
  end
end
