module Users
  class EmailLogEntry < ActiveRecord::Base
    include PgSearch
    include Concerns::LongIdModelConcern

    belongs_to :user, inverse_of: :email_log_entries

    validates :user, presence: true
    validates :to, presence: true
    validates :subject, presence: true
    validates :body, presence: true

    pg_search_scope :search,
                    against: { subject: 'C', body: 'A', to: 'B' },
                    associated_against: {
                        user: { email: 'C', first_name: 'B', last_name: 'B' },
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }
  end
end