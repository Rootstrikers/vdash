Vdash::Application.routes.draw do
  root to: 'home#index'
  resources :links
  resources :users, only: [:show]

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'auth/failure', to: 'sessions#failure'
end
