Vdash::Application.routes.draw do
  root to: 'home#index'

  # RSS feeds
  namespace :feeds do
    resources :tweets, only: [:index]
    resources :facebook_posts, only: [:index]
  end

  # User-submitted content
  resources :links do
    resources :contents, except: [:index, :show]
  end

  # User stuff
  resources :users, only: [:show]
  resources :likes, only: [:create, :destroy]

  # Authentication
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'signin', to: 'home#sign_in'
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'auth/failure', to: 'sessions#failure'

  # Misc
  get 'help', to: 'help#index'
  resource :remote_link

  # Admin things
  namespace :admin do
    resources :posts, only: [:index, :create]
    resources :notices
    resources :contents, only: [:index]
    resources :bans, only: [:index]

    # Deleted things
    namespace :deleted_things do
      resources :contents, only: [:index]
      resources :links, only: [:index]
    end

    # User-specific things
    namespace :users do
      resources :bans, only: [:index, :new, :create, :destroy]
    end
  end
end
