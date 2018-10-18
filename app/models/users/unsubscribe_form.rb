module Users
  class UnsubscribeForm
    include ActiveModel::Model
    include Virtus.model

    attribute :email, String
    attribute :receive_security_bulletins, Boolean, default: true
    attribute :receive_product_announcements, Boolean, default: true

    validates :email, presence: true, email: true

    validate :check_email_exists

    def email=(value)
      super(value.downcase)
    end

    def user_params
      {
          receive_security_bulletins: receive_security_bulletins,
          receive_product_announcements: receive_product_announcements,
      }.select { |_, v| !v }
    end

    private
    def check_email_exists
      unless Users::User.exists?(email: email)
        errors[:email] << 'is invalid'
      end
    end
  end
end