require 'spec_helper'

describe Accounts::Account do
  let(:account) { create(:account) }

  describe ".with_expiring_credit_card" do
    let!(:account_expiring) { create(:account, stripe_expiration_date: Time.zone.today + 3.months - 1.day) }
    let!(:account_expired) { create(:account, stripe_expiration_date: Time.zone.today - 1.month) }
    let!(:account_non_expiring) { create(:account, stripe_expiration_date: Time.zone.today + 1.year) }

    it "includes accounts expiring in the next 3 months" do
      expect(Accounts::Account.with_expiring_credit_card).to include(account_expiring)
    end

    it "does not include accounts expiring after the next 3 months" do
      expect(Accounts::Account.with_expiring_credit_card).to_not include(account_non_expiring)
    end

    it "does not include accounts that have already expired" do
      expect(Accounts::Account.with_expiring_credit_card).to_not include(account_expired)
    end
  end

  describe "#credit_card_valid?" do
    context "when the stripe id is nil" do
      let(:account) { create(:account, stripe_id: nil, stripe_valid: true) }

      it "is false" do
        expect(account.credit_card_valid?).to be_falsey
      end
    end

    context "when stripe valid is false" do
      let(:account) { create(:account, stripe_id: 'cus_abc', stripe_valid: false) }

      it "is false" do
        expect(account.credit_card_valid?).to be_falsey
      end
    end

    context "when the card has expired" do
      let(:account) { create(:account, stripe_id: 'cus_abc', stripe_valid: true, stripe_expiration_date: Time.zone.today - 1.month) }

      it "is false" do
        expect(account.credit_card_valid?).to be_falsey
      end
    end

    context "when everything checks out" do
      let(:account) { create(:account, stripe_id: 'cus_abc', stripe_valid: true, stripe_expiration_date: Time.zone.today + 1.month) }

      it "is true" do
        expect(account.credit_card_valid?).to be_truthy
      end
    end
  end

  describe "#balance_favorable?" do
    context "when the account balance is less than $1" do
      it "returns true" do
        expect(account.balance_favorable?).to be_truthy
      end
    end

    context "when the account balance is greater than or equal to $1" do
      before { create :transaction, account: account, amount: 100 }

      it "returns false" do
        expect(account.balance_favorable?).to be_falsey
      end
    end
  end

  describe "#add_debit" do
    it "changes the account balance" do
      expect { account.add_debit(500, "test debit") }.to change { account.balance }.by(500)
    end
  end

  describe "#add_refund" do
    it "changes the account balance" do
      expect { account.add_refund(500, "test refund") }.to change { account.balance }.by(500)
    end
  end

  describe "#add_credit" do
    it "changes the account balance" do
      expect { account.add_credit(500, "test credit") }.to change { account.balance }.by(-500)
    end
  end

  describe "#add_referral" do
    it "changes the account balance" do
      expect { account.add_referral(500, "test referral") }.to change { account.balance }.by(-500)
    end
  end

  describe "#add_payment" do
    let(:credit_card) { Accounts::CreditCard.new(type: 'Visa', last_4: '4242') }

    it "changes the account balance" do
      expect { account.add_payment(500, 45, credit_card, "ch_123") }.to change { account.balance }.by(-500)
    end
  end
end