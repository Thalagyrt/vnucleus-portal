# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if Rails.env.production?
  BetaforceCom::Application.config.secret_token = ENV['SECRET_TOKEN']
else
  # Development/test token
  BetaforceCom::Application.config.secret_token = '90bc1355777dfc4080a53c64b1d13deecee951d213e8b735d93d8035aef4572b3dfe074b350f9e57b86cda2884f385043172693fe2cde4740ebbb24412163835'
end
