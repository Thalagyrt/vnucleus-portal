require 'stripe'

Stripe.api_key = Rails.configuration.stripe[:secret_key]