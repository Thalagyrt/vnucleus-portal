module Users
  module OneTimePasswords
    class EnableForm
      include ActiveModel::Model

      attr_accessor :otp, :otp_secret, :user

      validate :validate_otp

      validates :otp, presence: true
      validates :otp_secret, presence: true

      def initialize(attributes = {})
        super

        @otp_secret ||= ROTP::Base32.random_base32
      end

      def qr_code
        @qr_code ||= RQRCode::QRCode.new(provisioning_uri).as_html.html_safe
      end

      private
      def provisioning_uri
        rotp.provisioning_uri(user.email)
      end

      def validate_otp
        unless rotp.verify_with_drift(otp, 30)
          errors[:otp] << :invalid
        end
      end

      def rotp
        @rotp ||= ROTP::TOTP.new(otp_secret, issuer: 'vNucleus')
      end
    end
  end
end