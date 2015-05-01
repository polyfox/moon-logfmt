require 'spec_helper'
require 'moon-logfmt/logfmt'

describe Moon::Logfmt::Logger do
  context '#initialize' do
    it 'initializes a new logger without arguments' do
      logger = described_class.new
    end

    it 'initializes a new logger with context arguments' do
      logger = described_class.new fn: 'test'

      expect(logger.send(:context)).to eq(fn: 'test')
    end
  end

  context '#initialize_copy' do
    it 'initializes a copy' do
      logger = described_class.new fn: 'test'
      c = logger.dup

      expect(c.send(:context)).to eq(logger.send(:context))
      expect(c.send(:context)).not_to equal(logger.send(:context))
    end
  end

  context '#write' do
    it 'writes a new log line' do
      logger = Moon::Logfmt::NullLogger.new fn: 'test'
      logger.write msg: 'Test Test Test'
    end
  end
end
