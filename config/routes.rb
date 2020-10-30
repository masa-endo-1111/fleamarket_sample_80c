Rails.application.routes.draw do
  devise_for :users
  
  devise_scope :users do
    get '/users', to: redirect("/users/sign_up")
  end

  root 'items#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: :show
  resources :items, only: [:index, :new, :create, :show]
end
