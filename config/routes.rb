Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'home/about', to: 'static_pages#about'
  get 'users/sign_up', to: 'users#new'
  post 'users/sign_up', to: 'users#create'
  get 'users/sign_in', to: 'sessions#new'
  post 'users/sign_in', to: 'sessions#create'
  delete 'users/sign_out', to: 'sessions#destroy'
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :postbooks, only: [:show, :index, :create, :edit, :update, :destroy]
end
