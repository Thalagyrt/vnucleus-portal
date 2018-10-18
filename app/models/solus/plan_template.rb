module Solus
  class PlanTemplate < ActiveRecord::Base
    belongs_to :plan
    belongs_to :template

    validates :plan, presence: true
    validates :template, presence: true
  end
end