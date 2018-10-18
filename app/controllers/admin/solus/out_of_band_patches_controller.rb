module Admin
  module Solus
    class OutOfBandPatchesController < ::Admin::ApplicationController
      power :admin_solus_servers, as: :servers_scope

      before_filter :assign_templates

      def new
        @out_of_band_patch_form = ::Solus::OutOfBandPatchForm.new
      end

      def create
        out_of_band_patch_creator = ::Solus::OutOfBandPatchCreator.new(servers_scope: servers_scope)

        out_of_band_patch_creator.on(:create_success) do
          flash[:notice] = 'The affected servers have been marked for patching.'
          redirect_to [:admin, :dashboard]
        end

        out_of_band_patch_creator.on(:create_failure) do |out_of_band_patch_form|
          @out_of_band_patch_form = out_of_band_patch_form
          render :new
        end

        out_of_band_patch_creator.create(out_of_band_patch_form_params)
      end

      private
      def assign_templates
        @templates = ::Solus::Template.with_active_servers.sorted
      end

      def out_of_band_patch_form_params
        params.require(:out_of_band_patch_form).permit(:managed_only, :template_ids => [])
      end
    end
  end
end