require 'spec_helper'

describe Admin::Dashboard do
  subject do
    described_class.new(
        tickets: Tickets::Ticket.all,
        transactions: Accounts::Transaction.all,
        solus_servers: Solus::Server.all,
        solus_clusters: Solus::Cluster.all,
        accounts: Accounts::Account.all,
        users: Users::User.all,
        licenses: Licenses::License.all,
        dedicated_servers: Dedicated::Server.all,
    )
  end

  describe "Accounts" do
    describe "#accounts_pending_welcome" do
      let!(:account_pending_welcome) { create :account, welcome_state: :pending }
      let!(:account) { create :account }

      context "when the account has a user with a confirmed email" do
        let!(:user) { create :user, email_confirmed: true }
        before { account_pending_welcome.memberships.create(user: user, roles: [:full_control]) }

        context "and the account has a monthly run rate" do
          let!(:server) { create :solus_server, account: account_pending_welcome, state: :active, amount: 1000 }

          it "includes accounts with a pending welcome state" do
            expect(subject.accounts_pending_welcome).to include(account_pending_welcome)
          end
        end

        context "and the account has no monthly run rate" do
          it "does not include accounts with a pending welcome state" do
            expect(subject.accounts_pending_welcome).to_not include(account_pending_welcome)
          end
        end
      end

      context "when the account does not have a user with a confirmed email" do
        it "does not include accounts that have completed welcome" do
          expect(subject.accounts_pending_welcome).to_not include(account_pending_welcome)
        end
      end

      it "does not include accounts that have completed welcome" do
        expect(subject.accounts_pending_welcome).to_not include(account)
      end
    end

    describe "#open_tickets" do
      let!(:open_ticket) { create :ticket, status: :open }
      let!(:closed_ticket) { create :ticket, status: :closed }

      it "includes open tickets" do
        expect(subject.open_tickets).to include(open_ticket)
      end

      it "does not include closed tickets" do
        expect(subject.open_tickets).to_not include(closed_ticket)
      end
    end

    describe "#current_solus_servers" do
      let!(:server) { create :solus_server, state: :active }

      it "returns the count of active solus servers" do
        expect(subject.current_solus_servers).to eq(1)
      end
    end
  end

  describe "NodeHealth" do
    let(:cluster) { create :solus_cluster }
    let!(:nodes) do
      2.times.map do
        create :solus_node, cluster: cluster, ram_limit: 128.gigabytes, allocated_ram: 96.gigabytes,
               disk_limit: 128.gigabytes, available_disk: 32.gigabytes
      end
    end

    describe "#available_ram" do
      it "sums the available ram of all nodes" do
        expect(subject.available_ram).to eq(64.gigabytes)
      end
    end

    describe "#ram_limit" do
      it "sums the ram limit of all nodes" do
        expect(subject.ram_limit).to eq(256.gigabytes)
      end
    end

    describe "#used_ram" do
      it "returns the difference between ram limit and available ram" do
        expect(subject.used_ram).to eq(192.gigabytes)
      end
    end

    describe "#ram_utilization" do
      it "returns the percentage of used ram" do
        expect(subject.ram_utilization).to eq(75)
      end
    end

    describe "#available_disk" do
      it "sums the available disk of all nodes" do
        expect(subject.available_disk).to eq(64.gigabytes)
      end
    end

    describe "#disk_limit" do
      it "sums the disk limit of all nodes" do
        expect(subject.disk_limit).to eq(256.gigabytes)
      end
    end

    describe "#used_disk" do
      it "returns the difference between disk limit and available disk" do
        expect(subject.used_disk).to eq(192.gigabytes)
      end
    end

    describe "#disk_utilization" do
      it "returns the percentage of used disk" do
        expect(subject.disk_utilization).to eq(75)
      end
    end
  end

  describe "Financials" do
    describe "#income_this_year" do
      let!(:payment_this_year) { create :transaction_payment, amount: -1000 }
      let!(:payment_last_year) { create :transaction_payment, amount: -1000, created_at: 1.year.ago }

      it "returns the sum of payments for the year" do
        expect(subject.income_this_year).to eq(1000)
      end
    end

    describe "#monthly_rate" do
      let(:account) { create :account }
      let!(:active_server) { create :solus_server, account: account, state: :active, plan_amount: 1000 }
      let!(:canceled_server) { create :solus_server, account: account, state: :user_terminated, plan_amount: 1000 }
      let!(:license) { create :license, account: account }

      it "returns the total amount of active servers and licenses" do
        expect(subject.monthly_rate).to eq(active_server.amount + license.amount)
      end
    end
  end
end