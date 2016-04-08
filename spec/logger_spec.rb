require 'spec_helper'
require 'moon-logfmt/logfmt'

describe Moon::Logfmt::Logger do
  let(:null_logger) { @null_logger ||= Moon::Logfmt::NullLogger.new(fn: 'test') }

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
      null_logger.write msg: 'Test Test Test'
    end
  end

  context 'std logger interface' do
    context '#level=' do
      it 'will accept symbols' do
        null_logger.level = :debug
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::DEBUG)

        null_logger.level = :info
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::INFO)

        null_logger.level = :warn
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::WARN)

        null_logger.level = :error
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::ERROR)

        null_logger.level = :fatal
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::FATAL)

        null_logger.level = :unknown
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::UNKNOWN)
      end

      it 'will accept strings' do
        null_logger.level = 'debug'
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::DEBUG)
      end

      it 'will accept integers' do
        null_logger.level = 0
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::DEBUG)

        null_logger.level = 5
        expect(null_logger.level).to eq(Moon::Logfmt::Severity::UNKNOWN)
      end

      it 'will fail given an invalid level' do
        expect { null_logger.level = :something }.to raise_error(ArgumentError)
      end
    end

    context '#info' do
      it 'writes a basic message' do
        null_logger.info 'Test Test Test'
      end
    end

    context '#debug' do
      it 'writes a debug message' do
        null_logger.debug { 'Test Test Test' }
      end
    end

    context '#warn' do
      it 'writes a warning message' do
        null_logger.warn { 'Test Test Test' }
      end
    end

    context '#error' do
      it 'writes a warning message' do
        null_logger.error('testapp') { 'Test Test Test' }
      end
    end

    context '#fatal' do
      it 'writes a fatal message' do
        null_logger.fatal 'AND I DIED'
      end
    end

    context '#warn' do
      it 'writes a unknown message' do
        # more like a spooky message
        null_logger.unknown { 'Spoooooky' }
      end
    end
  end
end
