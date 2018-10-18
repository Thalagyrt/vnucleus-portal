module Solus
  class TemplatesController < ::ApplicationController
    decorates_assigned :templates

    power :user_solus_plans, as: :plans_scope
    power :user_solus_plan_templates, context: :plan, as: :templates_scope

    def show
      @templates = templates_scope.sorted
    end

    private
    def plan
      plans_scope.find(params[:plan_id])
    end
  end
end