module Users
  class EnhancedSecurityToken < ActiveRecord::Base
    include Concerns::LongIdModelConcern

    belongs_to :user, inverse_of: :enhanced_security_tokens

    validates :user, presence: true
    validates :token, uniqueness: { scope: :user_id }

    before_create :seen
    before_create :assign_authorization_code

    scope :find_active, -> { where('expires_at > ?', Time.zone.now) }
    scope :find_expired, -> { where('expires_at <= ?', Time.zone.now) }

    def self.clean_up
      find_expired.delete_all
    end

    def expired?
      expires_at <= Time.zone.now
    end

    def seen!(opts = {})
      seen(opts)
      save!
    end

    def seen(opts = {})
      if authorized?
        duration = Rails.application.config.enhanced_security_token[:authorized_duration]
      else
        duration = Rails.application.config.enhanced_security_token[:unauthorized_duration]
      end

      if opts[:request].present?
        self.last_seen_ip_address = opts[:request].remote_ip
        self.user_agent = opts[:request].user_agent
      end

      self.expires_at = Time.zone.now + duration
    end

    private
    def assign_authorization_code
      self.authorization_code = StringGenerator.long_id
    end
  end
end