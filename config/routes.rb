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
  resources :contents, only: [:index]

  # User stuff
  resources :users, only: [:show, :edit, :update]
  resources :likes, only: [:create]
  resources :clicks, only: [:create]

  # Authentication
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'signin', to: 'home#sign_in'
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'auth/failure', to: 'sessions#failure'

  resources :linked_accounts, only: [:index]

  # Misc
  get 'help', to: 'help#index'
  resource :remote_link

  # Admin things
  namespace :admin do
    resources :posts, only: [:index, :create] do
      get :callback, on: :collection
    end
    resources :notices
    resources :bans, only: [:index]

    # Deleted things
    namespace :deleted_things do
      resources :contents, only: [:index]
      resources :links, only: [:index]
    end

    # User-specific things
    resources :users, only: [] do
      resources :bans, only: [:index, :new, :create, :destroy], controller: 'users/bans'
    end
  end
end
