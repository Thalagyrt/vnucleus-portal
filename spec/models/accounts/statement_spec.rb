require 'spec_helper'

describe Accounts::Statement do
  let(:start_date) { Time.zone.today.at_beginning_of_month }
  let(:account) { create :account }

  let!(:current_transactions)  { 3.times.map { create :transaction, account: account, created_at: start_date + 1.week } }
  let!(:previous_transactions) { 3.times.map { create :transaction, account: account, created_at: start_date - 1.week } }
  let!(:future_transactions)   { 3.times.map { create :transaction, account: account, created_at: start_date + 5.weeks } }

  subject { described_class.new(transactions_scope: account.transactions, start_date: start_date) }

  describe "#id" do
    it "returns the year and month" do
      expect(subject.id).to eq(start_date.strftime("%Y-%m"))
    end
  end

  describe "#to_s" do
    it "returns the year and month in readable form" do
      expect(subject.to_s).to eq(start_date.strftime("%B %Y"))
    end
  end

  describe "#starting_balance" do
    it "returns the balance of transactions prior to the statement" do
      expect(subject.starting_balance).to eq(previous_transactions.sum(&:amount))
    end
  end

  describe "#ending_balance" do
    it "returns the sum of the previous + current transactions" do
      expect(subject.ending_balance).to eq(previous_transactions.sum(&:amount) + current_transactions.sum(&:amount))
    end
  end

  describe "#transactions" do
    it "includes current transactions" do
      current_transactions.each do |transaction|
        expect(subject.transactions).to include(transaction)
      end
    end

    it "does not include previous transactions" do
      previous_transactions.each do |transaction|
        expect(subject.transactions).to_not include(transaction)
      end
    end

    it "does not include future transactions" do
      future_transactions.each do |transaction|
        expect(subject.transactions).to_not include(transaction)
      end
    end
  end
end