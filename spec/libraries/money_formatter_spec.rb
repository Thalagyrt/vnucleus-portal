require 'spec_helper'

describe MoneyFormatter do
  describe '::format_amount' do
    it 'formats positive amounts' do
      expect(MoneyFormatter.format_amount(995)).to eq('$9.95')
    end

    it 'formats zero' do
      expect(MoneyFormatter.format_amount(0)).to eq('$0.00')
    end

    it 'formats negative amounts' do
      expect(MoneyFormatter.format_amount(-995)).to eq('($9.95)')
    end
  end
end