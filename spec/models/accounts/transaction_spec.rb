require 'spec_helper'

describe Accounts::Transaction do
  describe "#to_s" do
    let(:transaction) { create :transaction }

    it "returns the transaction description" do
      expect(transaction.to_s).to eq("#{transaction.category.humanize} #{transaction.reference}")
    end
  end

  describe ".find_in_year" do
    context "with a transaction at the start of the year" do
      let!(:transaction) { create :transaction, created_at: '2014-01-01 00:00:00' }

      it "includes the transaction" do
        expect(described_class.find_in_year(2014)).to include(transaction)
      end
    end

    context "with a transaction at the end of the year" do
      let!(:transaction) { create :transaction, created_at: '2014-12-31 23:59:59' }

      it "includes the transaction" do
        expect(described_class.find_in_year(2014)).to include(transaction)
      end
    end

    context "with a transaction outside of the year" do
      let!(:transaction) { create :transaction, created_at: '2013-12-31 23:59:59' }

      it "does not include the transaction" do
        expect(described_class.find_in_year(2014)).to_not include(transaction)
      end
    end
  end

  describe ".total" do
    let!(:transactions) { 3.times.map { create :transaction, amount: 10 } }

    it "returns the sum of transactions" do
      expect(described_class.total).to eq(30)
    end
  end
end