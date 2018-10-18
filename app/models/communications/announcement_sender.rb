module Communications
  class AnnouncementSender
    include Wisper::Publisher

    def initialize(opts = {})
      @announcement = opts.fetch(:announcement)
      @sender = opts.fetch(:sender)
      @mailer = opts.fetch(:mailer) { Mailer }
    end

    def send
      if announcement.update_attributes(sent_at: Time.zone.now, sent_by: sender)
        Rails.logger.info { "Sending announcement #{announcement}" }

        target_users.each do |user|
          mailer.delay.announcement_posted(user: user, announcement: announcement)
        end

        publish :send_success
      else
        publish :send_failure
      end
    end

    private
    attr_reader :announcement, :sender, :mailer
    delegate :target_users, to: :announcement
  end
end