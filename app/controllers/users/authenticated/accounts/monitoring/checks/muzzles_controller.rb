module Users
  module Authenticated
    module Accounts
      module Monitoring
        module Checks
          class MuzzlesController < Users::Authenticated::Accounts::Monitoring::Checks::ApplicationController
            def new
              @muzzle = ::Monitoring::Muzzle.new
            end

            def create
              check_muzzler = ::Monitoring::CheckMuzzler.new(check: @check)

              check_muzzler.on(:muzzle_success) do
                flash[:notice] = 'The check has been updated.'
                render :create
              end

              check_muzzler.on(:muzzle_failure) do |muzzle|
                @muzzle = muzzle
                render :new
              end

              check_muzzler.muzzle(muzzle_params)
            end

            private
            def muzzle_params
              params.require(:muzzle).permit(:duration)
            end
          end
        end
      end
    end
  end
end