Vdash::Application.routes.draw do
  root to: 'home#index'
  resources :links
end
