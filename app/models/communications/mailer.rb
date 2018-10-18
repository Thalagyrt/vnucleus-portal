module Communications
  class Mailer < ActionMailer::Base
    default from: '"vNucleus" <noreply@vnucleus.com>'

    def announcement_posted(opts)
      @user = opts.fetch(:user)
      @announcement = opts.fetch(:announcement).decorate

      mail(to: @user.email, subject: @announcement.email_subject)
    end
  end
end