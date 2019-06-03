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

  get 'names/generate(/:syllables_count)', to: 'names#generate', defaults: { syllables_count: '3' }

  resources :characters, only: %i[show]
  resources :castles,    only: %i[index show]

  resources :accounts, only: %i[show create update destroy] do
    resources :characters, only: [] do
      get :index, on: :collection, to: 'characters#index_by_account'
    end
  end

  resources :camps, only: %i[index show] do
    post 'siege_weapons/build', to: 'siege_weapons#build'
    post 'characters/join', to: 'characters#join'

    resources :siege_weapons, only: %i[index show] do
      post :arm, on: :member
    end

    resources :characters, only: [] do
      get :index, on: :collection, to: 'characters#index_by_camp'
    end
  end
end
