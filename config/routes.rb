Rails.application.routes.draw do
  constraints(AdminRouteConstraint) do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  namespace :users do
    resources :profile, only: %i[index update]
  end

  root to: redirect('/users/sign_in')
  resources :dashboard, only: %i[index]

  resources :plaid, only: %i[create]

  resources :invest_sets, only: %i[new create]
  get '/invest_sets/transactions', to: 'invest_sets#transactions', as: :invest_set_transactions

  resources :source_accounts, only: %i[new create]
  resources :invest_accounts, only: %i[new create]
  resources :invest_transactions, only: %i[create]

  get '/terms', to: 'pages#terms', as: :terms
  put '/users/profile', to: 'users/profile#update', as: :update_profile
end
