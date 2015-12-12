Rails.application.routes.draw do
  resources :items
  match 'item/:id/pro', :to => 'items#pro', :as => 'item_pro', :via => :post
  match 'item/:id/buy', :to => 'items#buy', :as => 'user_buy', :via => :post
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  match 'admin/signup' => 'users#admin_new', :user_type => 'admin', :via => :get, as: 'admin_signup'
  match 'owner/signup' => 'users#owner_new', :user_type => 'owner', :via => :get, as: 'owner_signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resources :users
  match 'user/:id/change_role', :to => 'users#change_role', :as => 'user_change_role', :via => :post
  root 'items#index'
end
