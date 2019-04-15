Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  post :login, to: 'login#create'
  post :refresh, to: 'refresh#create'

  namespace :game_actions do
    resources :siege_weapons, only: [] do
      post :arm
    end
  end

  scope module: 'resources' do
    resources :accounts
    resources :camps, only: %i[index show]
    resources :castles, only: %i[index show]
    resources :characters, only: %i[index show]
    resources :siege_weapons, only: %i[index show]
  end
end
