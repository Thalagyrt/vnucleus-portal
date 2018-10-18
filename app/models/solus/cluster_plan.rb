module Solus
  class ClusterPlan < ActiveRecord::Base
    belongs_to :cluster
    belongs_to :plan

    validates :cluster, presence: true
    validates :plan, presence: true
  end
end