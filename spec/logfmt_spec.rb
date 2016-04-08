require 'spec_helper'
require 'moon-logfmt/logfmt'

describe Moon::Logfmt do
  context '.new' do
    it 'creates a new Logger instance' do
      logger = described_class.new
      expect(logger).to be_instance_of(Moon::Logfmt::Logger)
    end
  end

  context '.escape_context_data' do
    it 'formats a Hash to a String' do
      actual = described_class.escape_context_data(msg: 'Hello World', nums: [1, 2, 3]).to_a
      expect(actual).to eq([['msg', '"Hello World"'], ['nums', '1,2,3']])
    end
  end
end
