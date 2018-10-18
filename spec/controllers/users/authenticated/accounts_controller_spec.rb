require 'spec_helper'

describe Users::Authenticated::AccountsController do
  it_behaves_like "a protected user controller"

  context "with a logged in user" do
    let!(:user) { create :user_with_account }
    let(:account) { user.accounts.first }

    before do
      sign_in user
    end

    describe "#index" do
      it "assigns @accounts" do
        get :index

        expect(assigns(:accounts)).to be_present
      end
    end

    describe "#new" do
      it "assigns @account_form" do
        get :new

        expect(assigns(:account_form)).to be_present
      end
    end

    describe "#create" do
      let!(:user) { create :user }

      context "with a valid form" do
        let(:account_form_params) do
          {
              account_entity_name: 'Derpy', credit_card_token: 'tok_123', credit_card_name: 'Derpy Bogsworth',
              credit_card_address_line1: '123 Hayden Lane', credit_card_address_city: 'Derpsville',
              credit_card_address_state: 'Florida', credit_card_address_zip: '31337',
              credit_card_address_country: 'United States of America'
          }
        end

        let(:customer) { double(:customer).as_null_object }
        before { allow(Stripe::Customer).to receive(:create).and_return(customer) }
        before do
          stub_request(:post, 'https://minfraud.maxmind.com/app/ccv2r').to_return(
              status: 200,
              body: 'distance=7;countryMatch=Yes;countryCode=US;freeMail=No;anonymousProxy=No;binMatch=NA;binCountry=;
                 err=;proxyScore=0.00;ip_region=FL;ip_city=Miami;ip_latitude=25.7052;ip_longitude=-80.4633;
                 binName=;ip_isp=Comcast Cable;ip_org=Comcast Cable;binNameMatch=NA;binPhoneMatch=NA;binPhone=;
                 custPhoneInBillingLoc=NotFound;highRiskCountry=No;queriesRemaining=7923;cityPostalMatch=Yes;
                 shipCityPostalMatch=;maxmindID=ET542TIO;ip_asnum=AS7922 Comcast Cable Communications, Inc.;
                 ip_userType=residential;ip_countryConf=99;ip_regionConf=99;ip_cityConf=92;ip_postalCode=33193;
                 ip_postalConf=42;ip_accuracyRadius=4;ip_netSpeedCell=Cable/DSL;ip_metroCode=528;ip_areaCode=305;
                 ip_timeZone=America/New_York;ip_regionName=Florida;ip_domain=comcast.net;ip_countryName=United States;
                 ip_continentCode=NA;ip_corporateProxy=No;riskScore=100;prepaid=;
                 minfraud_version=1.3;service_level=standard'
          )
        end

        it "redirects away from the form" do
          post :create, account_form: account_form_params

          expect(response).to be_redirect
        end

        it "adds the user to the account" do
          expect {
            post :create, account_form: account_form_params
          }.to change {
            user.accounts.count
          }.by(1)
        end

        it "leaves the account pending" do
          post :create, account_form: account_form_params

          expect(user.accounts.first.state).to eq('pending_activation')
        end

        context "when maxmind comes back clear" do
          before do
            stub_request(:post, 'https://minfraud.maxmind.com/app/ccv2r').to_return(
                status: 200,
                body: 'distance=15636;explanation=lol;isTransProxy=Yes;countryMatch=No;countryCode=TH;freeMail=No;
                 anonymousProxy=No;binMatch=NA;binCountry=;err=;proxyScore=0.00;ip_region=38;ip_city=Nonthaburi;
                 ip_latitude=13.8622;ip_longitude=100.5134;binName=;ip_isp=True Internet;ip_org=True Internet;
                 binNameMatch=NA;binPhoneMatch=NA;binPhone=;custPhoneInBillingLoc=NotFound;highRiskCountry=Yes;
                 queriesRemaining=7924;cityPostalMatch=Yes;shipCityPostalMatch=;maxmindID=X9O6H6PD;
                 ip_asnum=AS17552 True Internet Co.,Ltd.;ip_userType=residential;ip_countryConf=99;ip_regionConf=9;
                 ip_cityConf=9;ip_postalCode=;ip_postalConf=;ip_accuracyRadius=13;ip_netSpeedCell=Dialup;
                 ip_metroCode=0;ip_areaCode=0;ip_timeZone=Asia/Bangkok;ip_regionName=Nonthaburi;
                 ip_domain=asianet.co.th;ip_countryName=Thailand;ip_continentCode=AS;ip_corporateProxy=No;
                 riskScore=0.20;prepaid=;minfraud_version=1.3;service_level=standard'
            )
          end

          it "sets the account active" do
            post :create, account_form: account_form_params

            expect(user.accounts.first.state).to eq('active')
          end
        end
      end

      context "with an invalid form" do
        let(:account_form_params) do
          {
              account_name: '', credit_card_token: 'tok_123', credit_card_name: 'Derpy Bogsworth',
              credit_card_address_line1: '123 Hayden Lane', credit_card_address_city: 'Derpsville',
              credit_card_address_state: 'Florida', credit_card_address_zip: '31337',
              credit_card_address_country: 'United States of America'
          }
        end

        let(:customer) { double(:customer).as_null_object }
        before { allow(Stripe::Customer).to receive(:create).and_return(customer) }

        it "renders the new template" do
          post :create, account_form: account_form_params

          expect(response).to render_template(:new)
        end

        it "assigns @account_form" do
          post :create, account_form: account_form_params

          expect(assigns(:account_form)).to be_present
        end
      end
    end

    context "with a valid account" do
      let(:membership) { user.account_memberships.first }

      before do
        sign_in user
      end

      describe "#show" do
        it "assigns @account" do
          get :show, id: account.to_param

          expect(assigns(:account)).to be_present
        end
      end

      context "with full control" do
        describe "#edit" do
          it "assigns @account" do
            get :edit, id: account.to_param

            expect(assigns(:account)).to be_present
          end
        end

        describe "#update" do
          context "with valid params" do
            it "redirects to the account" do
              put :update, id: account.to_param, account: { entity_name: 'Testy' }

              expect(response).to be_redirect
            end
          end

          context "with invalid params" do
            it "redirects to the account" do
              put :update, id: account.to_param, account: { entity_name: '' }

              expect(response).to render_template(:edit)
            end
          end
        end
      end

      context "without full control" do
        before { membership.update_attributes roles: [:manage_servers] }

        describe "#edit" do
          it "returns 404" do
            get :edit, id: account.to_param

            expect(response.status).to eq(404)
          end
        end

        describe "#update" do
          it "returns 404" do
            put :update, id: account.to_param, account: { entity_name: 'Testy' }

            expect(response.status).to eq(404)
          end
        end
      end
    end
  end
end