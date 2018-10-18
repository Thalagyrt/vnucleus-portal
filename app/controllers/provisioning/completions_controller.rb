module Provisioning
  class CompletionsController < Provisioning::ApplicationController
    def show
      completion_service.provision_complete

      render json: { status: :ok }, status: :ok
    end

    private
    def completion_service
      Solus::ServerProvisionCompletionService.new(server: server)
    end
  end
end