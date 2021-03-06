Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/addresses', to: 'users/registrations#new_address'
    post '/addresses', to: 'users/registrations#create_address'
  end

  root 'items#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: :show
  
  resources :items do
    resources :comments, only: :create
    collection do
    get :search_category
    end
    resources :purchases, only: [:index ,:create,:show]
  end

  resources :pays, only: [:new, :show,:create ] do
    collection do
      post 'delete', to: 'pays#delete'
    end
  end

  resources :categories do
    collection do
      get :search_category
    end
  end
end
