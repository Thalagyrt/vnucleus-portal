module Users
  class EmailLogger
    def self.delivered_email(message)
      subject = message.subject.to_s
      if message['X-vNucleus-No-Log-Body'].present?
        body = "This message body was not logged for security purposes."
      else
        body = message.body.to_s
      end

      message.to.each do |to|
        EmailLogEntry.create(
                         to: to,
                         subject: subject,
                         body: body,
                         user: User.find_by_email(to),
        )
      end
    end
  end
end