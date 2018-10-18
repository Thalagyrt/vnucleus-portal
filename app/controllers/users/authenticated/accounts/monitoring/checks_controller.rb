module Users
  module Authenticated
    module Accounts
      module Monitoring
        class ChecksController < ::Users::Authenticated::Accounts::ApplicationController
          power :account_monitoring_checks, context: :load_account, as: :checks_scope

          decorates_assigned :checks, :check, :check_view

          def index
            @checks = checks_scope
            @checks = @checks.find_failing unless params[:show_successful].present?

            respond_to do |format|
              format.html
              format.json { render json: ChecksDatatable.new(@checks, view_context) }
            end
          end

          def show
            start = Time.zone.parse(params[:start].to_s) || Time.zone.now - 24.hours
            finish = Time.zone.parse(params[:finish].to_s) || Time.zone.now

            @check_view = ::Monitoring::CheckView.new(check: checks_scope.find_by_param(params[:id]), start: start, finish: finish)
          end

          def edit
            @check = checks_scope.find_by_param(params[:id])
          end

          def update
            @check = checks_scope.find_by_param(params[:id])

            if @check.update_attributes check_params
              flash[:notice] = 'The check has been updated.'
              redirect_to [:users, @account, :monitoring, @check]
            else
              render :edit
            end
          end

          def destroy
            check = checks_scope.find_by_param(params[:id])
            check.update_attributes deleted: true

            Delayed::Job.enqueue ::Monitoring::CheckDestroyer.new(check: check), priority: Rails.application.config.low_queue_priority

            flash[:notice] = 'The check has been deleted.'
            redirect_to [:users, @account, :monitoring, :checks]
          end

          def check_params
            params.require(:check).permit(:check_data, :notify_account, :notify_after_failures)
          end
        end
      end
    end
  end
end