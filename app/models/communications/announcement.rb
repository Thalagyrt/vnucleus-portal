module Communications
  class Announcement < ActiveRecord::Base
    extend Enumerize

    enumerize :announcement_type, in: { security_bulletin: 1, product_announcement: 2, service_announcement: 3 }

    belongs_to :sent_by, class_name: ::Users::User

    validates :subject, presence: true
    validates :body, presence: true
    validates :announcement_type, presence: true

    scope :find_unsent, -> { where(sent_at: nil) }

    def to_s
      subject
    end

    def email_subject
      case announcement_type.to_sym
        when :security_bulletin
          "[Security] #{subject}"
        when :product_announcement
          "[Product] #{subject}"
        when :service_announcement
          "[Service] #{subject}"
        else
          subject
      end
    end

    def target_users
      case announcement_type.to_sym
        when :security_bulletin
          ::Users::User.find_receiving_security_bulletins
        when :product_announcement
          ::Users::User.find_receiving_product_announcements
        when :service_announcement
          ::Users::User.find_mailable.find_with_active_service
        else
          raise ArgumentError.new("Invalid Announcement Type")
      end
    end

    def sent?
      sent_at.present?
    end
  end
end