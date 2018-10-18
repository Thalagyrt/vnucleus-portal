shared_examples 'a protected user controller' do |skip_actions|
  context "without a logged in user" do
    let(:protected_controller_options) { defined?(request_options) ? request_options : {} }
    let(:protected_controller_resource_id) { defined?(resource) ? resource.id : 1 }

    describe "#index", if: described_class.instance_methods.include?(:index) && [*skip_actions].exclude?(:index) do
      it "redirects to login" do
        get :index, protected_controller_options

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end

    describe "#show", if: described_class.instance_methods.include?(:show) && [*skip_actions].exclude?(:show) do
      it "redirects to login" do
        get :show, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end

    describe "#new", if: described_class.instance_methods.include?(:new) && [*skip_actions].exclude?(:new) do
      it "redirects to login" do
        get :new, protected_controller_options

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end

    describe "#create", if: described_class.instance_methods.include?(:create) && [*skip_actions].exclude?(:create) do
      it "redirects to login" do
        post :create, protected_controller_options

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end

    describe "#edit", if: described_class.instance_methods.include?(:edit) && [*skip_actions].exclude?(:edit) do
      it "redirects to login" do
        get :edit, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end

    describe "#update", if: described_class.instance_methods.include?(:update) && [*skip_actions].exclude?(:update) do
      it "redirects to login" do
        put :update, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end

    describe "#destroy", if: described_class.instance_methods.include?(:destroy) && [*skip_actions].exclude?(:destroy) do
      it "redirects to login" do
        delete :destroy, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_sessions_session_path)
      end
    end
  end
end


shared_examples 'a protected admin controller' do |skip_actions|
  context "without an admin user" do
    let(:user) { create :user }
    let(:protected_controller_options) { defined?(request_options) ? request_options : {} }
    let(:protected_controller_resource_id) { defined?(resource) ? resource.id : 1 }

    before { sign_in user }

    describe "#index", if: described_class.instance_methods.include?(:index) && [*skip_actions].exclude?(:index) do
      it "renders 404" do
        get :index, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#show", if: described_class.instance_methods.include?(:show) && [*skip_actions].exclude?(:show) do
      it "renders 404" do
        get :show, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#new", if: described_class.instance_methods.include?(:new) && [*skip_actions].exclude?(:new) do
      it "renders 404" do
        get :new, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#create", if: described_class.instance_methods.include?(:create) && [*skip_actions].exclude?(:create) do
      it "renders 404" do
        post :create, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#edit", if: described_class.instance_methods.include?(:edit) && [*skip_actions].exclude?(:edit) do
      it "renders 404" do
        get :edit, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#update", if: described_class.instance_methods.include?(:update) && [*skip_actions].exclude?(:update) do
      it "renders 404" do
        put :update, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#destroy", if: described_class.instance_methods.include?(:destroy) && [*skip_actions].exclude?(:destroy) do
      it "renders 404" do
        delete :destroy, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end
  end

  context "without two factor enabled" do
    let(:user) { create :staff_user, otp_secret: nil }
    let(:protected_controller_options) { defined?(request_options) ? request_options : {} }
    let(:protected_controller_resource_id) { defined?(resource) ? resource.id : 1 }

    before { sign_in user }

    describe "#index", if: described_class.instance_methods.include?(:index) && [*skip_actions].exclude?(:index) do
      it "redirects to the two factor enable form" do
        get :index, protected_controller_options

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end

    describe "#show", if: described_class.instance_methods.include?(:show) && [*skip_actions].exclude?(:show) do
      it "redirects to the two factor enable form" do
        get :show, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end

    describe "#new", if: described_class.instance_methods.include?(:new) && [*skip_actions].exclude?(:new) do
      it "redirects to the two factor enable form" do
        get :new, protected_controller_options

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end

    describe "#create", if: described_class.instance_methods.include?(:create) && [*skip_actions].exclude?(:create) do
      it "redirects to the two factor enable form" do
        post :create, protected_controller_options

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end

    describe "#edit", if: described_class.instance_methods.include?(:edit) && [*skip_actions].exclude?(:edit) do
      it "redirects to the two factor enable form" do
        get :edit, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end

    describe "#update", if: described_class.instance_methods.include?(:update) && [*skip_actions].exclude?(:update) do
      it "redirects to the two factor enable form" do
        put :update, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end

    describe "#destroy", if: described_class.instance_methods.include?(:destroy) && [*skip_actions].exclude?(:destroy) do
      it "redirects to the two factor enable form" do
        delete :destroy, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response).to redirect_to(new_users_one_time_passwords_enables_path)
      end
    end
  end
end

shared_examples 'a protected account controller' do |skip_actions|
  context "with an invalid account" do
    let(:user) { create :user }
    let(:protected_controller_options) { (defined?(request_options) ? request_options : {}).merge(account_id: 1) }

    before { sign_in user }

    describe "#index", if: described_class.instance_methods.include?(:index) && [*skip_actions].exclude?(:index) do
      it "renders 404" do
        get :index, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#show", if: described_class.instance_methods.include?(:show) && [*skip_actions].exclude?(:show) do
      it "renders 404" do
        get :show, protected_controller_options.merge(id: 1)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#new", if: described_class.instance_methods.include?(:new) && [*skip_actions].exclude?(:new) do
      it "renders 404" do
        get :new, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#create", if: described_class.instance_methods.include?(:create) && [*skip_actions].exclude?(:create) do
      it "renders 404" do
        post :create, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#edit", if: described_class.instance_methods.include?(:edit) && [*skip_actions].exclude?(:edit) do
      it "renders 404" do
        get :edit, protected_controller_options.merge(id: 1)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#update", if: described_class.instance_methods.include?(:update) && [*skip_actions].exclude?(:update) do
      it "renders 404" do
        put :update, protected_controller_options.merge(id: 1)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#destroy", if: described_class.instance_methods.include?(:destroy) && [*skip_actions].exclude?(:destroy) do
      it "renders 404" do
        delete :destroy, protected_controller_options.merge(id: 1)

        expect(response.response_code).to eq(404)
      end
    end
  end

  context "with an unauthorized user" do
    let(:user) { create :user }
    let(:protected_controller_account) { defined?(account) ? account : create(:account) }
    let(:protected_controller_resource_id) { defined?(resource) ? resource.id : 1 }
    let(:protected_controller_options) { (defined?(request_options) ? request_options : {}).merge(account_id: protected_controller_account.to_param) }

    before { sign_in user }

    describe "#index", if: described_class.instance_methods.include?(:index) && [*skip_actions].exclude?(:index) do
      it "renders 404" do
        get :index, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#show", if: described_class.instance_methods.include?(:show) && [*skip_actions].exclude?(:show) do
      it "renders 404" do
        get :show, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#new", if: described_class.instance_methods.include?(:new) && [*skip_actions].exclude?(:new) do
      it "renders 404" do
        get :new, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#create", if: described_class.instance_methods.include?(:create) && [*skip_actions].exclude?(:create) do
      it "renders 404" do
        post :create, protected_controller_options

        expect(response.response_code).to eq(404)
      end
    end

    describe "#edit", if: described_class.instance_methods.include?(:edit) && [*skip_actions].exclude?(:edit) do
      it "renders 404" do
        get :edit, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#update", if: described_class.instance_methods.include?(:update) && [*skip_actions].exclude?(:update) do
      it "renders 404" do
        put :update, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end

    describe "#destroy", if: described_class.instance_methods.include?(:destroy) && [*skip_actions].exclude?(:destroy) do
      it "renders 404" do
        delete :destroy, protected_controller_options.merge(id: protected_controller_resource_id)

        expect(response.response_code).to eq(404)
      end
    end
  end
end
