require 'coverage_helper'

ENV["RAILS_ENV"] = 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'faker'
require 'rack_session_access/capybara'
require 'capybara-screenshot/rspec'
require 'webmock/rspec'

WebMock.disable_net_connect! allow_localhost: true

#ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara::Webkit.configure do |config|
  config.debug = !!ENV['DEBUG']
end

Capybara.configure do |config|
  config.default_max_wait_time = 15
  config.javascript_driver = :webkit
end

Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  url = example.example_group_instance.page.current_path.gsub('/', '.')
  description = example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')

  "screenshot_#{description}_#{url}"
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature
  config.include Features::ChosenHelpers, type: :feature
  config.include Controllers::SessionHelpers, type: :controller
  config.include Common::MailerHelpers
  config.include Common::SolusHelpers
  config.include Common::WisperMatchers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    reset_email

    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start

    allow(Time.zone).to receive(:today).and_return(Time.zone.today)
    allow(Time.zone).to receive(:now).and_return(Time.zone.now)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order opts. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
