BetaforceCom::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

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
      # No auth as binding should fail, we don't want to ever hit AD in our tests
  }

  config.bcrypt_cost = 4

  config.show_live_chat = false

  # Session access for integration tests
  config.middleware.use RackSessionAccess::Middleware

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.eager_load = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = true

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
end

Delayed::Worker.delay_jobs = false
