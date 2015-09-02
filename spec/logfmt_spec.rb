require 'spec_helper'
require 'moon-logfmt/logfmt'

describe Moon::Logfmt do
  context '.escape_context_data' do
    it 'formats a Hash to a String' do
      actual = described_class.escape_context_data(msg: 'Hello World', nums: [1, 2, 3]).to_a
      expect(actual).to eq([['msg', '"Hello World"'], ['nums', '1,2,3']])
    end
  end
end
