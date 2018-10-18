# Be sure to restart your server when you modify this file.

BetaforceCom::Application.config.session_store :active_record_store, key: '_betaforce.com_session', expire_after: 24.hours

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# BetaforceCom::Application.config.session_store :active_record_store
