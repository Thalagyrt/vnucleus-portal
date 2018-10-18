module Admin
  module Solus
    class TemplatesController < Admin::ApplicationController
      power :admin_solus_templates, as: :templates_scope

      decorates_assigned :templates, :template

      def index
        @templates = templates_scope
        @templates = @templates.active unless params[:show_all].present?
      end

      def new
        @template = templates_scope.new
      end

      def create
        @template = templates_scope.new(template_params)

        if @template.save
          flash[:notice] = 'The template has been saved.'
          redirect_to [:admin, :solus, :templates]
        else
          render :new
        end
      end

      def edit
        @template = templates_scope.find(params[:id])
      end

      def update
        @template = templates_scope.find(params[:id])

        if @template.update_attributes(template_params)
          flash[:notice] = 'The template has been updated.'
          redirect_to [:admin, :solus, :templates]
        else
          render :edit
        end
      end

      private
      def template_params
        params.require(:template).permit(
            :name, :amount_dollars, :template, :plan_part, :virtualization_type, :description, :root_username,
            :status, :autocomplete_provision, :category, :affinity_group, :preseed_template, :generate_root_password, :plan_ids => []
        )
      end
    end
  end
end