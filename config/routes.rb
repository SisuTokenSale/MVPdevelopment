Rails.application.routes.draw do
  devise_for :users

  get 'welcome/show'

  resource :user, only: %i[show edit update] do
    resources :accounts
  end
  post 'plaid/apply_token', to: 'plaid#apply_token'

  root to: 'welcome#index'
end
