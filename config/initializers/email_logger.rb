require 'users/email_logger'

ActionMailer::Base.register_observer(Users::EmailLogger)