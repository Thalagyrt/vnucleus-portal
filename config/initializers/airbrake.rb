Airbrake.configure do |config|
  config.api_key = ''
  config.environment_name = begin
    if Rails.env.production?
      ENV['AIRBRAKE_ENVIRONMENT']
    else
      Rails.env
    end
  end
end
