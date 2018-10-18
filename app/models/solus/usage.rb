module Solus
  class Usage < ActiveRecord::Base
    belongs_to :template, inverse_of: :usages
    belongs_to :node, inverse_of: :usages
  end
end