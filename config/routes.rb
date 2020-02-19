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

  get 'names/generate(/:syllables_count)', to: 'names#generate', defaults: { syllables_count: '4' }

  resources :accounts, shallow: true do
    resources :characters
  end

  resources :castles

  resources :camps, shallow: true do
    post :build, on: :member
    post :join, on: :member

    resources :characters
    resources :siege_machines do
      post :arm, on: :member
    end
  end
end
