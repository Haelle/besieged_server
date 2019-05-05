Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    admin_email    = Rails.application.credentials.admin_email
    admin_password = Rails.application.credentials.admin_password
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(admin_email)) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(admin_password))
  end

  mount Sidekiq::Web => '/sidekiq'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  post :login_with_email, to: 'login#login_with_email'
  post :login,            to: 'login#login_with_id'
  post :refresh,          to: 'refresh#create'

  namespace :game_actions do
    resources :camps, only: [] do
      post :join
    end

    resources :siege_weapons, only: [] do
      post :arm
    end

    post 'siege_weapons/build', to: 'siege_weapons#build'
  end

  namespace :resources do
    resources :accounts,      only: %i[show create update destroy]
    resources :camps,         only: %i[index show]
    resources :castles,       only: %i[index show]
    resources :characters,    only: %i[index show]
    resources :siege_weapons, only: %i[index show]
  end
end
