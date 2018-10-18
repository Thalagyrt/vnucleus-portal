set :rvm_type, :user
set :airbrake_env, 'staging'

role :web, 'portal-staging.cent.betaforce.com'
role :app, 'portal-staging.cent.betaforce.com'
role :db, 'portal-staging.cent.betaforce.com', primary: true
