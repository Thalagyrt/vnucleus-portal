module Solus
  class Image
    include ActiveModel::Model

    attr_accessor :data, :content_type
  end
end