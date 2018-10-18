module Ahoy
  class Visit < ActiveRecord::Base
    include PgSearch

    has_many :solus_servers, class_name: Solus::Server
    has_many :accounts, class_name: Accounts::Account

    has_many :events, inverse_of: :visit

    belongs_to :user, inverse_of: :visits, class_name: Users::User

    pg_search_scope :search,
                    against: [:utm_medium, :utm_campaign, :utm_source, :ip],
                    associated_against: {
                        user: [:first_name, :last_name]
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }
  end

end