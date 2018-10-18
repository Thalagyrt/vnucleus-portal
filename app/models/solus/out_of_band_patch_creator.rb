module Solus
  class OutOfBandPatchCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @servers_scope = opts.fetch(:servers_scope)
    end

    def create(params)
      @out_of_band_patch_form = OutOfBandPatchForm.new(params)

      if out_of_band_patch_form.valid?
        affected_servers.update_all patch_out_of_band: true

        publish :create_success
      else
        publish :create_failure, out_of_band_patch_form
      end
    end

    private
    attr_reader :servers_scope, :out_of_band_patch_form
    delegate :template_ids, :managed_only?, to: :out_of_band_patch_form

    def affected_servers
      servers = servers_scope.find_active.where(template_id: template_ids)
      servers = servers.find_managed if managed_only?
      servers
    end
  end
end