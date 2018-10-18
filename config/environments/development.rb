BetaforceCom::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.rails_logger = true
  end

  config.nrpe = {
      ssl_cert: 'config/nrpe-dev.crt',
      ssl_key: 'config/nrpe-dev.key',
  }

  config.stripe = {
      secret_key: '',
      publishable_key: '',
  }

  config.pagerduty = {
      high_api_key: '',
      business_api_key: '',
      low_api_key: '',
  }

  config.console_server = {
      hostname: 'localhost',
      port: '5000',
      ws_port: '5001',
      vnc_uri: 'https://vnc.vnucleus.com',
      ssh_uri: 'wss://ssh.vnucleus.com',
      expires_after: 30.minutes,
  }

  config.active_directory = {
      host: 'cent1.cent.betaforce.com',
      base: 'dc=cent,dc=betaforce,dc=com',
      encryption: :simple_tls,
      port: 636,
      auth: {
          method: :simple,
          username: "portal-test@cent.betaforce.com",
          password: ""
      }
  }

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.smtp_settings = {
      :address              => '127.0.0.1',
      :port                 => '1025',
      :domain               => 'vnucleus.com',
      :enable_starttls_auto => true
  }

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false
end
