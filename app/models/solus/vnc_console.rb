module Solus
  class VncConsole
    include ActiveModel::Model
    include Draper::Decoratable

    attr_accessor :hostname, :port, :password

    def type
      :vnc
    end
  end
end