module Provisioning
  class PreseedsController < Provisioning::ApplicationController
    def show
      render text: @server.preseed_body
    end
  end
end