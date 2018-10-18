module Users
  class Token < ActiveRecord::Base
    belongs_to :user, inverse_of: :tokens

    validates :kind, presence: true

    before_create :assign_token
    before_create :assign_expires_at

    scope :find_expired, -> { where('expires_at < ?', Time.zone.now) }

    def self.clean_up
      find_expired.delete_all
    end

    def self.for(kind)
      create(kind: kind).token
    end

    def self.purge(kind)
      where(kind: kind).delete_all
    end

    def self.fetch(token, kind)
      where(token: token, kind: kind).first.tap do |token|
        raise ActiveRecord::RecordNotFound unless token.present?
        raise ActiveRecord::RecordNotFound unless token.active?
      end
    end

    def active?
      expires_at > Time.zone.now
    end

    private

    def assign_token
      loop do
        self.token = SecureRandom.uuid
        break unless self.class.exists?(kind: kind, token: token)
      end
    end

    def assign_expires_at
      self.expires_at ||= Time.zone.now + Rails.application.config.user_token_duration
    end
  end
end