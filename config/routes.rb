Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post :login, to: 'login#create'
  post :refresh, to: 'refresh#create'

  scope module: 'resources' do
    resources :accounts
    # cannot update camp there is no attributes
    resources :camps, only: %i[index show create destroy]
    resources :castles
    resources :characters
    resources :siege_weapons
  end
end
