set :rvm_type, :user
set :airbrake_env, 'production'

role :web, 'portal.int.vnucleus.com'
role :app, 'portal.int.vnucleus.com'
role :db, 'portal.int.vnucleus.com', primary: true
