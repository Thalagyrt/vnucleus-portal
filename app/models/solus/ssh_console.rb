module Solus
  class SshConsole
    include ActiveModel::Model
    include Draper::Decoratable

    attr_accessor :hostname, :port, :username, :password

    def type
      :ssh
    end
  end
end