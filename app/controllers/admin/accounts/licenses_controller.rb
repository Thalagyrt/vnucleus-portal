module Admin
  module Accounts
    class LicensesController < Admin::Accounts::ApplicationController
      decorates_assigned :licenses, :license

      power :admin_account_licenses, context: :load_account, as: :licenses_scope

      def index
        @licenses = licenses_scope
      end

      def edit
        @license = licenses_scope.find(params[:id])
      end

      def update
        license_updater = ::Licenses::LicenseUpdater.new(license: licenses_scope.find(params[:id]))

        license_updater.on(:update_success) do
          flash[:notice] = 'The license has been updated.'
          redirect_to [:admin, @account, :licenses]
        end

        license_updater.on(:update_failure) do |license|
          @license = license
          render :edit
        end

        license_updater.update(update_license_params)
      end

      def new
        @license = licenses_scope.new
      end

      def create
        license_creator = ::Licenses::LicenseCreator.new(account: @account, license_factory: licenses_scope)

        license_creator.on(:create_success) do
          flash[:notice] = 'The license has been created.'
          redirect_to [:admin, @account, :licenses]
        end

        license_creator.on(:create_failure) do |license|
          @license = license
          render :new
        end

        license_creator.create(create_license_params)
      end

      def destroy
        licenses_scope.find(params[:id]).update_attributes count: 0

        flash[:notice] = 'The license has been zeroed.'
        redirect_to [:admin, @account, :licenses]
      end

      private
      def update_license_params
        params.require(:license).permit(:note, :count, :free)
      end

      def create_license_params
        params.require(:license).permit(:product_id, :note, :count, :free)
      end
    end
  end
end