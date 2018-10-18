require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module BetaforceCom
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.accept_orders = true
    config.show_live_chat = false
    config.billing_enabled = true

    # Precompile css/js assets that we load up separately
    config.assets.precompile += [
        'vendor/modernizr-2.6.2-respond-1.1.0.min.js',
    ]

    config.automation = {
        suspend_after: 7.days,
        terminate_after: 21.days,
    }

    config.tickets = {
        trigger_incident_after: {
            normal: 1.hour,
            critical: 5.minutes,
        },
        pagerduty_api_key: {
            normal: :business_api_key,
            critical: :high_api_key,
        }
    }

    config.enhanced_security_token = {
        authorized_duration: 3.months,
        unauthorized_duration: 6.hours,
    }

    config.console_locks = {
        duration: 5.seconds,
        heartbeat: 2.seconds
    }

    config.fog = {
        provider: :aws,
        aws_access_key_id: ENV['FOG_AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['FOG_AWS_SECRET_ACCESS_KEY']
    }

    config.ptr_cache_time = 600

    config.new_account_credit_amount = 10_00

    config.notification_cutoff = 7.days

    config.domain_validation_dns_name = 'domain-validation.vnucleus.com'

    # Enqueue mailers at a lower priority than everything else so they don't clog up the queue. Email can wait, server installs and other actions can't.
    config.mailer_queue_priority = 5
    config.low_queue_priority = 10

    # Cost to target for BCrypt passwords
    config.bcrypt_cost = 12

    config.show_live_chat = true

    config.recent_transaction_threshold = 7.days

    config.affiliate_payout_period = 3.months
    config.affiliate_recurring_factor = 0.05

    config.user_token_duration = 1.hour

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    config.maxmind_threshold = 7.5
    config.maxmind_license_key = ENV['MAXMIND_KEY']

    config.account_inactive_period = 60.days
    config.credit_card_removal_period = 7.days

    config.transfer_overage_amount = 10 # cents per gigabyte

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :credit_card]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(File.join(Rails.root, 'log', "#{Rails.env}.log")))
    config.log_tags = [-> req { "X-Request-Id: #{req.uuid}" }]
  end
end
