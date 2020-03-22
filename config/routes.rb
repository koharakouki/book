Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'home/about', to: 'static_pages#about'
  get 'users/sign_up', to: 'users#new'
  post 'users/sign_up', to: 'users#create'
  resources :users
end
