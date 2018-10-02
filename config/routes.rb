Rails.application.routes.draw do
  devise_for :users

  get 'welcome/show'

  resource :user, only: [:show, :edit, :update] do
    post 'get_token'
    resources :accounts
  end

  root to: 'welcome#index'
end
