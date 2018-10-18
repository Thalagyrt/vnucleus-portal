BetaforceCom::Application.routes.draw do
  root to: 'pages#index'
  get '/about', to: 'pages#about'
  get '/pricing', to: 'pages#pricing'
  get '/our-team', to: 'pages#our_team', as: :our_team
  get '/tos', to: 'pages#tos'
  get '/aup', to: 'pages#aup'
  get '/privacy', to: 'pages#privacy'
  get '/managed-support-coverage', to: 'pages#managed_support_coverage', as: :managed_support_coverage
  get '/self-managed-support-coverage', to: 'pages#self_managed_support_coverage', as: :self_managed_support_coverage
  get '/our-portal', to: 'pages#our_portal', as: :our_portal
  get '/our-clients', to: 'pages#our_clients', as: :our_clients
  get '/testimonials', to: 'pages#testimonials', as: :testimonials

  get '/order', to: redirect('/user/sign-up')

  get '/accounts', to: redirect { |_, request| "/client/accounts?#{request.query_string}" }
  get '/accounts/*path', to: redirect { |params, request| "/client/accounts/#{params[:path]}?#{request.query_string}" }
  get '/user/*path', to: redirect { |params, request| "/client/#{params[:path]}?#{request.query_string}" }

  resource :statuses, only: [:show], path: 'status'

  namespace :validations do
    resource :emails, only: [:create], path: 'email'
    resource :phones, only: [:create], path: 'phone'
    resource :hostnames, only: [:create], path: 'hostname'
    resource :stocks, only: [:show, :create], path: 'stock'
  end

  namespace :knowledge_base, path: 'kb' do
    resources :articles, path: '', only: [:index, :show]
  end

  namespace :blog do
    resources :posts, path: '', only: [:index]

    get '/:year',
        to: 'posts#index'
    get '/:year/:month',
        to: 'posts#index'
    get '/:year/:month/:day',
        to: 'posts#index'

    get '/:year/:month/:day/:id',
        to: 'posts#show', as: :post_date
  end

  namespace :users, path: 'client' do
    resources :registrations, only: [:new, :create], path: 'register', path_names: {new: ''}
    resources :sign_ups, only: [:new, :create], path: 'sign-up', path_names: {new: ''}
    resources :unsubscriptions, only: [:new, :create], path: 'unsubscribe', path_names: {new: ''}

    namespace :emails, path: 'email' do
      resource :confirmations, only: [:show], path: 'confirm'
    end

    namespace :passwords, path: 'password' do
      resources :tokens, only: [:new, :create], path: 'token', path_names: {new: ''}
      resources :resets, only: [:new, :create], path: 'reset', path_names: {new: ''}
    end

    namespace :sessions, path: 'session' do
      resource :session, only: [:new, :create, :destroy], path: '', path_names: {new: ''}
    end

    scope module: 'authenticated' do
      resources :accounts, only: [:index, :show, :new, :create, :edit, :update] do
        scope module: 'accounts' do
          resources :licenses, only: [:index]
          resources :statements, only: [:index, :show]
          resources :payments, only: [:new, :create]
          resources :events, only: [:index]
          resources :invites, only: [:index, :new, :create, :destroy]
          resources :memberships, only: [:index, :edit, :update, :destroy]
          resource :credit_cards, only: [:show, :edit, :update], path: 'credit-card'
          resource :affiliates, only: [:show], path: 'affiliate'

          namespace :monitoring do
            resources :checks, only: [:index, :show, :edit, :update, :destroy] do
              scope module: 'checks' do
                resource :enables, only: [:create], path: 'enable'
                resource :disables, only: [:create], path: 'disable'
                resource :muzzles, only: [:new, :create], path: 'muzzle', path_names: {new: ''}
              end
            end
          end

          namespace :solus, path: 'virtual' do
            resources :servers, only: [:index, :show, :new, :create] do
              scope module: 'servers' do
                resource :confirmations, only: [:new, :create, :destroy], path: 'confirm', path_names: {new: ''}
                resource :terminations, only: [:new, :create], path: 'terminate', path_names: {new: ''}
                resource :boots, only: [:create], path: 'boot'
                resource :reboots, only: [:create], path: 'reboot'
                resource :shutdowns, only: [:create], path: 'shutdown'
                resources :checks, only: [:index, :new, :create]
                resource :root_passwords, only: [:show], path: 'root-password'
                resources :ip_addresses, only: [:index, :edit, :update], path: 'ip-addresses',
                          :constraints => { :id => /[^\/]+(?=\.js\z)|[^\/]+/ }
                resource :statuses, only: [:show], path: 'status'
                resource :provision_progresses, only: [:show], path: 'provision-progress'
                resource :transfer_graphs, only: [:show], path: 'transfer-graph'
                resource :reinstalls, only: [:new, :create], path: 'reinstall', path_names: {new: ''}
                resource :consoles, only: [:show, :update, :destroy], path: 'console'
                resource :muzzles, only: [:new, :create], path: 'muzzle', path_names: {new: ''}
              end
            end
          end

          namespace :dedicated, path: 'dedicated' do
            resources :servers, only: [:index, :show] do
              scope module: 'servers' do
                resource :root_passwords, only: [:show], path: 'root-password'
              end
            end
          end

          resources :tickets, only: [:index, :show, :new, :create] do
            scope module: 'tickets' do
              resources :updates, only: [:index, :show, :new, :create]
            end
          end
        end

        get '/servers', to: redirect('/client/accounts/%{account_id}/virtual/servers')
        get '/servers/*path', to: redirect('/client/accounts/%{account_id}/virtual/servers/%{path}')
      end

      resource :profile, only: [:edit, :update]
      resource :legal_acceptances, only: [:create], path: 'legal-acceptance'
      resource :invites, only: [:show]
      resources :enhanced_security_tokens, only: [:index, :destroy], path: 'enhanced-security'
      resources :email_log_entries, only: [:index, :show], path: 'email-log-entries'
      resources :notifications, only: [:index, :show] do
        collection do
          namespace :notifications do
            resource :unread_counts, only: [:show], path: 'unread-count'
          end
        end
      end

      namespace :emails, path: 'email' do
        resources :tokens, only: [:create], path: 'token'
      end

      namespace :one_time_passwords, path: 'otp' do
        resource :statuses, only: [:show], path: ''
        resource :enables, only: [:new, :create], path: 'enable', path_names: {new: ''}
        resource :disables, only: [:new, :create], path: 'disable', path_names: {new: ''}
      end

      namespace :sessions, path: 'session' do
        resource :one_time_password, only: [:new, :create], path: 'otp', path_names: {new: ''}
        resource :enhanced_security_tokens, only: [:new, :create, :destroy], path: 'enhanced-security', path_names: {new: ''}
      end
    end
  end

  namespace :provisioning do
    resource :parameters, only: [:show]
    resource :preseeds, only: [:show]
    resource :completions, path: 'complete', only: [:show]
  end

  namespace :solus do
    resources :console_sessions, path: 'console-sessions', only: [:show], constraints: { id: /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ }
    resource :templates, only: [:show]
    resource :plans, only: [:show]
    resource :coupons, only: [:show]
    resource :service_levels, only: [:show]
    resources :enable_smtps, only: [:show], path: 'enable-smtp'
    resources :firewall_rules, only: [:show], path: 'firewall-rules'
  end

  namespace :admin, path: 'admin' do
    resource :dashboard, path: '', only: [:show]
    resource :analytics, only: [:show]
    resources :tickets, only: [:index]
    resources :users, only: [:index, :show] do
      scope module: 'users' do
        resources :visits, only: [:index]
        resources :email_log_entries, only: [:index], path: 'email-log-entries'
      end
    end
    resources :payments, only: [:index]
    resources :visits, only: [:index, :show]
    resources :email_log_entries, only: [:index, :show], path: 'email-log-entries'

    namespace :service do
      resources :notices, only: [:index, :create, :destroy]
    end

    namespace :licenses do
      resources :licenses, only: [:index], path: ''
      resources :usage_reports, only: [:index, :show], path: 'usage-reports'
    end

    namespace :communications do
      resources :announcements do
        scope module: 'announcements' do
          resource :sends, only: [:create], path: 'send'
        end
      end
    end

    namespace :monitoring do
      resources :checks, only: [:index, :show, :edit, :update, :destroy] do
        scope module: 'checks' do
          resource :enables, only: [:create], path: 'enable'
          resource :disables, only: [:create], path: 'disable'
          resource :muzzles, only: [:new, :create], path: 'muzzle', path_names: {new: ''}
        end
      end
    end

    resources :accounts, only: [:index, :show, :edit, :update] do
      scope module: 'accounts' do
        resources :licenses, only: [:index, :new, :create, :edit, :update, :destroy]
        resources :statements, only: [:index, :show]
        resources :events, only: [:index]
        resources :memberships, only: [:index]
        resources :notes, only: [:index, :new, :create, :destroy]
        resources :backup_users
        resource :activations, only: [:create, :destroy], path: 'activate'
        resource :credit_cards, only: [:show, :edit, :update], path: 'credit-card'
        resource :credits, only: [:new, :create], path: 'credit', path_names: {new: ''}
        resource :debits, only: [:new, :create], path: 'debit', path_names: {new: ''}

        namespace :solus, path: 'virtual' do
          resources :servers, only: [:index, :show, :new, :create, :edit, :update] do
            scope module: 'servers' do
              resource :boots, only: [:create], path: 'boot'
              resource :reboots, only: [:create], path: 'reboot'
              resource :shutdowns, only: [:create], path: 'shutdown'
              resource :root_passwords, only: [:show], path: 'root-password'
              resources :ip_addresses, only: [:index, :edit, :update], path: 'ip-addresses',
                        :constraints => { :id => /[^\/]+(?=\.js\z)|[^\/]+/ }
              resources :checks, only: [:index, :new, :create]
              resource :statuses, only: [:show], path: 'status'
              resource :provision_progresses, only: [:show], path: 'provision-progress'
              resource :suspensions, only: [:new, :create], path: 'suspend', path_names: {new: ''}
              resource :unsuspensions, only: [:new, :create], path: 'unsuspend', path_names: {new: ''}
              resource :terminations, only: [:new, :create], path: 'terminate', path_names: {new: ''}
              resource :transfer_graphs, only: [:show], path: 'transfer-graph'
              resource :consoles, only: [:show, :update, :destroy], path: 'console'
              resource :patches, only: [:new, :create], path: 'patch', path_names: {new: ''}
              resource :muzzles, only: [:new, :create], path: 'muzzle', path_names: {new: ''}
            end
          end
        end

        namespace :dedicated, path: 'dedicated' do
          resources :servers, only: [:index, :show, :new, :create, :edit, :update] do
            scope module: 'servers' do
              resource :root_passwords, only: [:show], path: 'root-password'
            end
          end
        end

        resources :tickets, only: [:index, :show, :new, :create] do
          scope module: 'tickets' do
            resources :updates, only: [:index, :show, :new, :create]
          end
        end
      end
    end

    namespace :solus, path: 'virtual' do
      resources :servers, only: [:index]
      resources :plans, only: [:index, :new, :create, :edit, :update]
      resources :templates, only: [:index, :new, :create, :edit, :update]
      resources :clusters, only: [:index, :show] do
        resource :synchronizations, only: [:create], path: 'synchronize'
      end
      resources :usage_reports, only: [:index, :show], path: 'usage-reports'

      resource :out_of_band_patches, only: [:new, :create], path: 'out-of-band-patches', path_names: {new: ''}
    end

    namespace :dedicated, path: 'dedicated' do
      resources :servers, only: [:index]
    end

    namespace :knowledge_base, path: 'kb' do
      resources :articles, path: ''
    end

    namespace :blog do
      resources :posts, path: ''
    end

    namespace :leads do
      resources :leads, path: ''
    end
  end
end
