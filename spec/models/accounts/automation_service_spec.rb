require 'spec_helper'

describe Accounts::AutomationService do
  let(:account) { create(:account) }
  subject { described_class.new(account: account) }

  before { allow(Delayed::Job).to receive(:enqueue) }

  describe "#in_favor" do
    let!(:pending_provision_server) { create(:solus_server, state: :pending_provision, account: account) }
    let!(:pending_automation_server) { create(:solus_server, state: :active, account: account, suspend_on: Time.zone.today + 7.days, terminate_on: Time.zone.today + 21.days) }
    let!(:automation_suspended_server) { create(:solus_server, state: :automation_suspended, account: account )}
    let!(:admin_suspended_server) { create(:solus_server, state: :admin_suspended, account: account )}
    before { account.update_attributes close_on: Time.zone.today + 21.days }

    it "clears the suspension date on active servers" do
      expect { subject.in_favor }.to change { pending_automation_server.reload.suspend_on }.to(nil)
    end

    it "clears the termination date on active servers" do
      expect { subject.in_favor }.to change { pending_automation_server.reload.terminate_on }.to(nil)
    end

    it "clears the close date on the account" do
      expect { subject.in_favor }.to change { account.reload.close_on }.to(nil)
    end

    it "enqueues provsion of servers that were pending provision" do
      job = double(:job)
      allow(Solus::ServerProvisionJob).to receive(:new).with(hash_including(server: pending_provision_server)).and_return(job)
      expect(Delayed::Job).to receive(:enqueue).with(job)

      subject.in_favor
    end

    it "enqueues unsuspension of servers that were automation suspended" do
      job = double(:job)
      allow(Solus::ServerAutomationUnsuspensionJob).to receive(:new).with(hash_including(server: automation_suspended_server)).and_return(job)
      expect(Delayed::Job).to receive(:enqueue).with(job)

      subject.in_favor
    end

    it "does not enqueue unsuspension of servers that were admin suspended" do
      expect(Solus::ServerAutomationUnsuspensionJob).to_not receive(:new).with(hash_including(server: admin_suspended_server))

      subject.in_favor
    end
  end

  describe "#out_of_favor" do
    let!(:active_server) { create(:solus_server, state: :active, suspend_on: Time.zone.today, account: account )}

    it "sets the close date" do
      expect { subject.out_of_favor }.to change { account.reload.close_on }.to(Time.zone.today + Rails.configuration.automation[:terminate_after])
    end

    context "with a server that does not have automation set" do
      let!(:server) { create(:solus_server, state: :active, account: account) }

      it "sets the suspension date" do
        expect { subject.out_of_favor }.to change { server.reload.suspend_on }.to(Time.zone.today + Rails.configuration.automation[:suspend_after])
      end

      it "sets the termination date" do
        expect { subject.out_of_favor }.to change { server.reload.terminate_on }.to(Time.zone.today + Rails.configuration.automation[:terminate_after])
      end
    end

    context "with a server that has automation set" do
      let!(:server) { create(:solus_server, state: :active, account: account, suspend_on: Time.zone.today + 7.days, terminate_on: Time.zone.today + 21.days) }

      it "does not change the suspension date" do
        expect { subject.out_of_favor }.to_not change { server.reload.suspend_on }
      end

      it "does not change the termination date" do
        expect { subject.out_of_favor }.to_not change { server.reload.terminate_on }
      end
    end

    it "enqueues suspension of servers that are due for suspension" do
      job = double(:job)
      allow(Solus::ServerAutomationSuspensionJob).to receive(:new).with(hash_including(server: active_server)).and_return(job)
      expect(Delayed::Job).to receive(:enqueue).with(job)

      subject.out_of_favor
    end
  end

  describe "#close_account" do
    let!(:active_server) { create(:solus_server, state: :active, account: account )}

    it "closes the account" do
      expect { subject.close_account }.to change { account.state }.to 'closed'
    end

    it "enqueues suspension of servers that are due for suspension" do
      job = double(:job)
      allow(Solus::ServerAutomationTerminationJob).to receive(:new).with(hash_including(server: active_server)).and_return(job)
      expect(Delayed::Job).to receive(:enqueue).with(job)

      subject.close_account
    end
  end
end