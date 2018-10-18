require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :use_sudo, false

set :stages, ['staging', 'production']
set :default_stage, 'staging'

set :application, 'betaforce'
set :repository, '.'
set :scm, :none
set :deploy_via, :copy
set :copy_exclude, ['.git', 'vendor', '.gitignore']

set :deploy_to, '/opt/betaforce/'
set :puma_pid, "#{deploy_to}/shared/pids/puma.pid"
set :delayed_job_glob, "#{deploy_to}/shared/pids/delayed_job.*.pid"
set :scheduler_daemon_pid, "#{deploy_to}/shared/pids/scheduler_daemon.pid"
set :keep_releases, 5

set :user, 'betaforce'

after "deploy", "deploy:cleanup"

namespace :deploy do
  after 'bundle:install' do
    run "cd -- #{current_release} && bundle exec rake RAILS_ENV=production db:migrate"
  end

  task :start do
  end

  task :stop do
    run "kill -QUIT `cat #{puma_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{puma_pid} ]; then sleep 3; kill -USR1 `cat #{puma_pid}`; fi"
    run "kill `cat #{delayed_job_glob}`"
    run "kill `cat #{scheduler_daemon_pid}`"
  end
end

require './config/boot'
require 'airbrake/capistrano'