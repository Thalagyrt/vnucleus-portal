module Monitoring
  class Mailer < ActionMailer::Base
    default from: '"vNucleus Monitoring" <noreply@vnucleus.com>'

    def check_status(opts)
      email = opts.fetch(:email)
      @check = opts.fetch(:check)

      mail(to: email, subject: @check.status_message)
    end
  end
end