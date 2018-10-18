module Solus
  class OutOfBandPatchForm
    include ActiveModel::Model
    include Virtus.model

    attribute :template_ids, Array[Integer]
    attribute :managed_only, Boolean, default: true

    validates :template_ids, presence: true
  end
end