require 'spec_helper'
require 'moon-logfmt/logfmt'

describe Moon::Logfmt do
  context '.format_context' do
    it 'formats a Hash to a String' do
      actual = described_class.format_context(msg: 'Hello World', nums: [1, 2, 3])
      expect(actual).to eq('msg="Hello World" nums=1,2,3')
    end
  end
end
