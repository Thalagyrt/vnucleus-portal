module Solus
  class ReinstallForm
    include ActiveModel::Model

    attr_accessor :server, :template_id

    validate :check_template_valid

    def templates
      server.plan.templates.active.sorted
    end

    def template
      Solus::Template.find(template_id)
    end

    def server_params
      {
          template_id: template_id
      }
    end

    private
    def check_template_valid
      unless templates.exists?(id: template_id)
        errors[:template_id] << 'invalid selection'
      end
    end
  end
end