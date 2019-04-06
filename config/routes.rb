Rails.application.routes.draw do
  post :login, to: 'login#create'
  post :refresh, to: 'refresh#create'

  scope module: 'resources' do
    resources :accounts
    resources :characters
    resources :siege_weapons
  end
end
