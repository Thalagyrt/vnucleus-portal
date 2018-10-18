module Admin
  module Accounts
    module Solus
      module Servers
        class TransferGraphsController < Admin::Accounts::Solus::Servers::ApplicationController
          skip_before_filter :update_current_user

          def show
            transfer_graph = ::Solus::GraphService.new(server: @server).transfer_graph

            return render_404 if transfer_graph.nil?

            send_data transfer_graph.data, type: transfer_graph.content_type, disposition: :inline
          end
        end
      end
    end
  end
end