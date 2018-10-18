module Accounts
  class BackupUser < ActiveRecord::Base
    belongs_to :account, inverse_of: :backup_users
    has_many :solus_servers, class_name: ::Solus::Server, inverse_of: :backup_user
    has_many :dedicated_servers, class_name: ::Dedicated::Server, inverse_of: :backup_user

    validates :username, presence: true
    validates :password, presence: true
    validates :hostname, presence: true

    def to_s
      "#{username}@#{hostname}"
    end
  end
end