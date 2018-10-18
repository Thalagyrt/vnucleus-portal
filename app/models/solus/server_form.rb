module Solus
  class ServerForm
    include ActiveModel::Model

    attr_accessor :hostname, :plan_id, :template_id, :cluster_id
    attr_accessor :coupon_code
    attr_accessor :current_power

    validates :hostname, hostname: true, presence: true
    validates :current_power, presence: true

    validates :cluster_id, inclusion: { in: proc { Solus::Cluster.pluck(:id) }, message: 'required' }
    validates :plan_id, inclusion: { in: proc { Solus::Plan.pluck(:id) }, message: 'required' }
    validates :template_id, inclusion: { in: proc { Solus::Template.pluck(:id) }, message: 'required' }

    validate :ensure_plan_available, if: proc { cluster_id.present? && plan_id.present? }
    validate :ensure_template_available, if: proc { cluster_id.present? && plan_id.present? && template_id.present? }
    validate :ensure_not_sold_out, if: proc { cluster_id.present? && plan_id.present? && template_id.present? }

    def plan_id=(value)
      @plan_id = value.to_i
    end

    def template_id=(value)
      @template_id = value.to_i
    end

    def cluster_id=(value)
      @cluster_id = value.to_i
    end
    
    def server_params
      {
          hostname: hostname,
          plan_id: plan_id,
          template_id: template_id,
          cluster_id: cluster_id
      }
    end

    private
    def template
      Solus::Template.find(template_id)
    end

    def plan
      Solus::Plan.find(plan_id)
    end

    def cluster
      Solus::Cluster.find(cluster_id)
    end

    def ensure_plan_available
      unless current_power.user_solus_cluster_plans(cluster).include?(plan)
        errors[:plan_id] << 'not available'
      end
    end

    def ensure_template_available
      unless current_power.user_solus_plan_templates(plan).include?(template)
        errors[:template_id] << 'not available'
      end
    end

    def ensure_not_sold_out
      unless cluster.select_node(plan).present?
        errors[:plan_id] << 'sold out'
      end
    end
  end
end