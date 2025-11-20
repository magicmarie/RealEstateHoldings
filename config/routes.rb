Rails.application.routes.draw do
  get "welcome/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # API routes
  namespace :api do
    namespace :v1 do
      resources :clients, only: [:index, :show]
      resources :buildings, only: [:index, :show, :create, :update] do
        collection do
          get :metadata
        end
      end
    end
  end

  # Defines the root path route ("/")
  root "welcome#index"
end
