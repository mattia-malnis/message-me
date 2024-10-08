Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "pages#index"

  devise_for :users

  get "profile", to: "profiles#show", as: "profile"
  get "profile/edit", to: "profiles#edit", as: "edit_profile"
  put "profile", to: "profiles#update"
  post "subscribe", to: "push_subscriptions#create"

  resources :chats, only: [:index, :show, :update, :new], param: :token do
    collection do
      get "search", to: "chats#search"
    end
  end
end
