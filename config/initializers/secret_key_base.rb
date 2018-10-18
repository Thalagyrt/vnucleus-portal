# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if Rails.env.production?
  BetaforceCom::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']
else
  # Development/test token
  BetaforceCom::Application.config.secret_key_base = '7fd44c7565bf43037b722ce3fcdcbee3851477a567e12b15b27c884bc087c080058144d4c8cba63babebc87dcafe687d219871d23ccd706b8e7b180dddf8923'
end
