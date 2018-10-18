ruby "2.2.5"

source 'https://rubygems.org'

gem 'dotenv-rails', :groups => [:development, :test]

gem 'rails', '~> 4.2.0'

gem 'activerecord-session_store'

# Asset pipeline
gem 'uglifier', '~> 2.7.2'
gem 'jquery-rails', '~> 3.1.2'
gem 'sass-rails', '~> 4.0.0'

# JSON
gem 'jbuilder', '~> 2.0.6'

# Handy default attributes
gem 'attribute-defaults', '~> 0.6.0'

# Visitor tracking
gem 'ahoy_matey', '~> 1.4.0'

# Enumeration
gem 'enumerize', '~> 0.8.0'

# Markdown
gem 'redcarpet', '~> 3.0'
gem 'coderay'

# Autolinking
gem 'rails_autolink', '~> 1.1.5'

# Phone validation
gem 'phonelib', '~> 0.3.0'

# Async
gem 'delayed_job_active_record', '~> 4.1.0'
gem 'daemons', '~> 1.1.9'

# Periodic jobs
gem 'scheduler_daemon', github: 'vNucleus/scheduler_daemon'
gem 'rufus-scheduler', '~> 2.0.0'

# Signals
gem 'wisper', '~> 1.6.0'

# Authorization
gem 'consul', '~> 0.12.0'
gem 'assignable_values', '~> 0.11.1'
gem 'role_model', '~> 0.8.1'

# Decorators
gem 'draper', '~> 1.3.0'

# AWS
gem 'fog-aws'

# Nav links
gem 'active_link_to', '~> 1.0.2'

# Paginationac
gem 'kaminari', '~> 0.15.1'
gem 'bootstrap-kaminari-views'

# Form helper
gem 'simple_form', '~> 3.1.0'
gem 'country_select', '~> 1.3.1'

# Form objects
gem 'virtus', '~> 1.0.4'

# Security
gem 'bcrypt', '~> 3.1.11'
gem 'rotp', '~> 1.6.1'

# XML Parser
gem 'nokogiri', '~> 1.6.2'

# QR Codes
gem 'rqrcode', '~> 0.10.1'

# HTTP Client
gem 'faraday', '~> 0.8.7'

# State management
gem 'state_machines-activerecord', '~> 0.4.0'

# Search
gem 'pg_search', '~> 0.7.4'

# Tags
gem 'acts-as-taggable-on', '~> 4.0'

# Database
gem 'pg', '~> 0.17.1'

# Deployment framework
gem 'capistrano', '~> 2.15.5'
gem 'rvm-capistrano', '~> 1.5.1', require: false

# Credit Card interface
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby', ref: '48f760'

# Profiling
# Was causing test failures with nokogiri-1.6.8? We don't use it much anyway
# gem 'rack-mini-profiler', '~> 0.9.2'

# Airbrake. Let's start collecting info on failures.
gem 'airbrake', '~> 4.1.0'

# Memcached
gem 'dalli'

# New Relic
gem 'newrelic_rpm'

# NRPE
gem 'nrpeclient', git: 'https://github.com/vNucleus/NrpeClient-Gem'

######## Scoped Gems ########

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'bullet', '~> 4.0'
  gem 'rubocop'
end

group :test do
  gem 'ci_reporter_rspec', '~> 1.0.0'
  gem 'rack_session_access', '~> 0.1'
  gem 'simplecov', '~> 0.11', require: false
  gem 'capybara', '~> 2.6'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'parallel_tests'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 1.2'
  gem 'faker', '~> 1.3'
  gem 'webmock', '~> 1.17'
end

group :production do
  gem 'puma', '~> 2.11.1'
end
