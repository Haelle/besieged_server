Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post :login, to: 'login#create'
  post :refresh, to: 'refresh#create'

  scope module: 'resources' do
    resources :accounts
    resources :camps, only: %i[index show]
    resources :castles, only: %i[index show]
    resources :characters, only: %i[index show]
    resources :siege_weapons, only: %i[index show]
  end
end
