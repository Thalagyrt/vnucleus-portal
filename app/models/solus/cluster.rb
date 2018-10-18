module Solus
  class Cluster < ActiveRecord::Base
    has_many :nodes
    has_many :servers
    has_many :cluster_plans
    has_many :plans, through: :cluster_plans

    validates :name, presence: true
    validates :hostname, hostname: true, presence: true
    validates :ip_address, presence: true
    validates :api_id, presence: true
    validates :api_secret, presence: true
    validates :facility, presence: true
    validates :transit_providers, presence: true

    def to_s
      "#{name} (#{id})"
    end

    concerning :Provisioning do
      # We have a concept of positive and negative affinity. If a template has negative affinity, it will avoid
      # provisioning on nodes that have the negative template on them.
      #
      # For example, if we have an Ubuntu and Windows template, with the following groups:
      #  Ubuntu: !windows
      #  Windows: windows
      #
      # This function, in that case, will attempt to provision Windows servers on nodes that already have Windows provisioned
      # At the same time, it will also attempt to provision Ubuntu servers on nodes that don't have Windows provisioned
      # The reasoning for this is simple - we want to try to keep as much space free for Windows as possible, not because
      # we sell a lot of it, but because doing so helps us keep our licensing costs down. By grouping our servers into
      # Windows and non-Windows, we're able to significantly lower our SPLA costs vs. blindly provisioning.
      def select_node(plan, template = nil)
        # We need to start from nodes within our given node group
        base_nodes = nodes.where(node_group: plan.node_group).includes(:cluster)

        if template.try(:affinity_group).present?
          negative_affinity = template.affinity_group.start_with?('!')

          # We want to slice out that ! if we have negative affinity
          affinity_group = negative_affinity ? template.affinity_group[1..-1] : template.affinity_group

          # Let's limit the nodes returned to those which have a template in that affinity group
          affinity_nodes = base_nodes.joins(:servers => :template).merge(Solus::Server.find_active).merge(Solus::Template.where(affinity_group: affinity_group))

          # If we have negative affinity, invert the selection
          affinity_nodes = base_nodes.where.not(id: affinity_nodes.pluck(:id)) if negative_affinity

          affinity_nodes = affinity_nodes.select { |node| node.stock(plan) > 0 }
        else
          affinity_nodes = []
        end

        base_nodes = base_nodes.select { |node| node.stock(plan) > 0 }

        # If we have any nodes remaining from above, sample them, otherwise let's sample the base nodes
        affinity_nodes.sample || base_nodes.sample
      end
    end

    concerning :Resources do
      def available_ram
        nodes.sum(:available_ram)
      end

      def ram_limit
        nodes.sum(:ram_limit)
      end

      def used_ram
        ram_limit - available_ram
      end

      def ram_utilization
        (used_ram / ram_limit * 100).to_i
      end

      def available_disk
        nodes.sum(:available_disk)
      end

      def disk_limit
        nodes.sum(:disk_limit)
      end

      def used_disk
        disk_limit - available_disk
      end

      def disk_utilization
        (used_disk / disk_limit * 100).to_i
      end
    end

    concerning :Stock do
      included do
        def self.stock(plan)
          all.map { |c| c.stock(plan) }.sum
        end
      end

      def stock(plan)
        nodes.where(node_group: plan.node_group).includes(:cluster).map { |node| node.stock(plan) }.sum
      end
    end

    concerning :Synchronization do
      def get_node(node_name)
        nodes.where(name: node_name).first_or_create
      end

      def prune_nodes(valid_nodes)
        nodes.where("name NOT IN (?)", valid_nodes).delete_all
      end
    end
  end
end