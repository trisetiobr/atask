Rails.application.routes.draw do
  root 'dashboard#index'
  resources :payment_transactions, only: [:new, :create]
  resources :withdraws, only: [:new, :create]
  resources :deposits, only: [:new, :create]

  get 'dashboard', to: 'dashboard#index'
  get 'login', to: 'users#login'
  post 'login', to: 'users#authenticate'
  get 'logout', to: 'users#logout'
end
