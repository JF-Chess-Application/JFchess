Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :games do
    resources :pieces
  end
end
