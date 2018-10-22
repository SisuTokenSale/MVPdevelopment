Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  root to: redirect('/users/sign_in')
  resources :dashboard, only: %i[index]

  resources :plaid, only: %i[create]
  # match 'plaid/:type',         to: 'plaid#create', via: :post

  resources :invest_sets, only: %i[new create]
  resources :source_accounts, only: %i[new create]
  resources :invest_accounts, only: %i[new create]
end
