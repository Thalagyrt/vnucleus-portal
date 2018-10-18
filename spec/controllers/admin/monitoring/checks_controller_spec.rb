require 'spec_helper'

describe Admin::Monitoring::ChecksController do
  it_behaves_like "a protected user controller"
  it_behaves_like "a protected admin controller"

  context "with an admin user" do
    let(:user) { create :staff_user }
    let(:account) { create :account }
    before { sign_in user }

    describe "#index" do
      let!(:passing_check) { create :check }
      let!(:disabled_check) { create :disabled_check }

      let!(:disabled_failing_check) { create :disabled_critical_check }
      let!(:failing_check) { create :critical_check }

      it "assigns @checks" do
        get :index

        expect(assigns(:checks)).to be_present
      end

      context "with default options" do
        before { get :index }

        it "includes the failing check" do
          expect(assigns(:checks)).to include(failing_check)
        end

        it "does not include the passing check" do
          expect(assigns(:checks)).to_not include(passing_check)
        end

        it "does not include the disabled passing check" do
          expect(assigns(:checks)).to_not include(disabled_check)
        end

        it "does not include the disabled failing check" do
          expect(assigns(:checks)).to_not include(disabled_failing_check)
        end
      end

      context "with show successful on" do
        before { get :index, show_successful: true }

        it "includes the failing check" do
          expect(assigns(:checks)).to include(failing_check)
        end

        it "includes the passing check" do
          expect(assigns(:checks)).to include(passing_check)
        end

        it "does not include the disabled passing check" do
          expect(assigns(:checks)).to_not include(disabled_check)
        end

        it "does not include the disabled failing check" do
          expect(assigns(:checks)).to_not include(disabled_failing_check)
        end
      end

      context "with show disabled on" do
        before { get :index, show_disabled: true }

        it "includes the failing check" do
          expect(assigns(:checks)).to include(failing_check)
        end

        it "does not include the passing check" do
          expect(assigns(:checks)).to_not include(passing_check)
        end

        it "does not include the disabled passing check" do
          expect(assigns(:checks)).to_not include(disabled_check)
        end

        it "includes the disabled failing check" do
          expect(assigns(:checks)).to include(disabled_failing_check)
        end
      end

      context "with show disabled and show successful on" do
        before { get :index, show_disabled: true, show_successful: true }

        it "includes the failing check" do
          expect(assigns(:checks)).to include(failing_check)
        end

        it "includes the passing check" do
          expect(assigns(:checks)).to include(passing_check)
        end

        it "includes the disabled passing check" do
          expect(assigns(:checks)).to include(disabled_check)
        end

        it "includes the disabled failing check" do
          expect(assigns(:checks)).to include(disabled_failing_check)
        end
      end
    end
  end
end