Rails.application.routes.draw do
  resources :items
  match 'item/:id/pro', :to => 'items#pro', :as => 'item_pro', :via => :post
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  match 'admin/signup' => 'users#new', :user => { :user_type => 'admin' }, :via => :get
  match 'owner/signup' => 'users#owner_new', :user => { :user_type => 'owner' }, :via => :get, as: 'owner'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resources :users
  root 'items#index'

end
