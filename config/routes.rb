Rails.application.routes.draw do
  resources :users
  get 'page/index'
  root 'page#index'

end
