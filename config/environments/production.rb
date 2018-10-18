BetaforceCom::Application.configure do
  config.accept_orders = false
  config.show_live_chat = false
  config.billing_enabled = false

  # Settings specified here will take precedence over those in config/application.rb
  config.action_mailer.default_url_options = { :protocol => ENV['PROTOCOL'], :host => ENV['HOSTNAME'] }
  config.action_mailer.smtp_settings = {
      :address              => ENV['MAIL_SERVER'],
      :port                 => ENV['MAIL_PORT'],
      :user_name            => ENV['MAIL_USER'],
      :password             => ENV['MAIL_PASSWORD'],
      :enable_starttls_auto => ENV['MAIL_TLS'].present?,
      :authentication       => :plain,
      :domain               => 'vnucleus.com',
  }

  config.nrpe = {
      ssl_cert: ENV['NRPE_CERT'],
      ssl_key: ENV['NRPE_KEY'],
  }

  config.stripe = {
      secret_key: ENV['STRIPE_SECRET_KEY'],
      publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  }

  config.pagerduty = {
      high_api_key: ENV['PAGERDUTY_HIGH_API_KEY'],
      business_api_key: ENV['PAGERDUTY_BUSINESS_API_KEY'],
      low_api_key: ENV['PAGERDUTY_LOW_API_KEY'],
  }

  config.console_server = {
      hostname: 'console.vnucleus.com',
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
          username: ENV['LDAP_BIND_USER'],
          password: ENV['LDAP_BIND_PASSWORD'],
      }
  }

  config.action_dispatch.trusted_proxies = %w(127.0.0.1).map { |p| IPAddr.new(p) }

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.css_compressor = :sass
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  #config.log_tags = [:uuid]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += ['vendor/modernizr-2.7.1-respond-1.4.2.min.js']

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
