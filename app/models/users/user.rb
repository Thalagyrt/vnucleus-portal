module Users
  class User < ActiveRecord::Base
    has_many :account_memberships, class_name: ::Accounts::Membership, dependent: :delete_all, inverse_of: :user
    has_many :accounts, class_name: ::Accounts::Account, through: :account_memberships
    has_many :events, inverse_of: :user
    has_many :email_log_entries, inverse_of: :user
    has_many :notifications, inverse_of: :user
    has_many :notes, class_name: ::Accounts::Note, inverse_of: :user
    has_many :enhanced_security_tokens, inverse_of: :user, dependent: :delete_all
    has_many :profile_changes, inverse_of: :user, dependent: :delete_all
    has_many :visits, inverse_of: :user, class_name: Ahoy::Visit, dependent: :nullify
    has_many :tokens, inverse_of: :user, dependent: :delete_all

    validates :email, email: true, uniqueness: true
    validates :first_name, presence: true, if: :profile_complete?
    validates :last_name, presence: true, if: :profile_complete?
    validates :phone, presence: true, phone: true, if: :profile_complete?
    validates :password,
              presence: true,
              length: { minimum: 8 },
              if: lambda{ new_record? || !password.nil? }

    scope :staff, -> { where(is_staff: true) }
    scope :find_online, -> { where('active_at > ?', 15.minutes.ago) }
    scope :find_active, -> { where(state: [:active]) }
    scope :find_complete_profiles, -> { where(profile_complete: true) }
    scope :find_email_confirmed, -> { where(email_confirmed: true) }
    scope :find_mailable, -> { find_active.find_complete_profiles.find_email_confirmed }
    scope :find_receiving_security_bulletins, -> { find_mailable.where(receive_security_bulletins: true) }
    scope :find_receiving_product_announcements, -> { find_mailable.where(receive_product_announcements: true) }
    scope :find_with_active_service, -> {
      ids_with_solus_servers = joins(accounts: :solus_servers).merge(::Solus::Server.find_active).pluck(:id)
      ids_with_dedicated_servers = joins(accounts: :dedicated_servers).merge(::Dedicated::Server.find_active).pluck(:id)

      where(id: [*ids_with_solus_servers, *ids_with_dedicated_servers])
    }

    def to_s
      "#{full_name} (email=#{email} id=#{id})"
    end

    def full_name
      if profile_complete?
        "#{first_name} #{last_name}"
      else
        email
      end
    end

    def greeting
      if profile_complete?
        first_name
      else
        email
      end
    end

    def email=(email)
      super(email.downcase)
    end

    concerning :Accounts do
      def current_accounts
        accounts.find_current
      end
    end

    concerning :Authentication do
      included do
        attr_reader :password
        attr_accessor :current_password, :password_confirmation
      end

      def authenticate(password)
        return false unless active?

        hash = BCrypt::Password.new(password_digest)

        if hash == password
          if hash.cost < Rails.application.config.bcrypt_cost
            self.password = password
            save
          end

          true
        else
          false
        end
      end

      def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password, cost: Rails.application.config.bcrypt_cost)
      end

      def otp_enabled?
        otp_secret.present?
      end
    end

    concerning :Email do
      included do
        before_save :update_email_confirmed

        def self.find_by_email_token(token)
          Token.fetch(token, :email).user
        end
      end

      def email_token
        tokens.for(:email)
      end

      private
      def update_email_confirmed
        if email_changed?
          self.email_confirmed = false
          tokens.purge(:email)
        end

        true
      end
    end

    concerning :EnhancedSecurity do
      def verify_enhanced_security_token!(token, opts = {})
        record = enhanced_security_tokens.find_active.where(token: token).first

        if record.present? && record.authorized?
          record.last_seen_at = Time.zone.now
          record.seen!(request: opts[:request])

          true
        else
          false
        end
      end
    end

    concerning :ProfileChanges do
      included do
        after_save :create_profile_change
      end

      private
      def create_profile_change
        if profile_changed?
          profile_changes.create(
              email: email, first_name: first_name, last_name: last_name,
              phone: phone, security_question: security_question, security_answer: security_answer
          )
        end
      end

      def profile_changed?
        email_changed? || first_name_changed? || last_name_changed? ||
            phone_changed? || security_question_changed? || security_answer_changed?
      end
    end

    concerning :Sessions do
      def expire_sessions
        self.session_generation = Time.zone.now
      end

      def expire_sessions!
        expire_sessions
        save!
      end
    end

    concerning :State do
      included do
        state_machine :state, initial: :active do
          event :ban do
            transition :active => :banned
          end

          before_transition any => :banned do |user, _|
            user.expire_sessions
          end
        end
      end
    end

    concerning :Tokens do
      included do
        after_save :purge_reset_tokens

        def self.find_by_reset_token(token)
          Token.fetch(token, :password).user
        end
      end

      def reset_token
        tokens.for(:password)
      end

      def purge_reset_tokens
        if email_changed? || password_digest_changed?
          tokens.purge(:password)
        end
      end
    end
  end
end