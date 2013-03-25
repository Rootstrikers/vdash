Vdash::Application.routes.draw do
  get "help/index"

  root to: 'home#index'
  get 'help', to: 'help#index'
  resources :twitter_contents, only: [:index]
  resources :facebook_contents, only: [:index]
  resources :links do
    resources :twitter_contents, except: [:show]
    resources :facebook_contents, except: [:index, :show]
  end
  resources :users, only: [:show]
  resources :likes, only: [:create, :destroy]

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'signin', to: 'home#sign_in'
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'auth/failure', to: 'sessions#failure'

  namespace :admin do
    resources :posts, only: [:index, :create]
    resources :notices
  end
end
