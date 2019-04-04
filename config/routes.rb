Rails.application.routes.draw do
  post :login, to: 'login#create'
  post :refresh, to: 'refresh#create'
  resources :accounts
  resources :characters
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
