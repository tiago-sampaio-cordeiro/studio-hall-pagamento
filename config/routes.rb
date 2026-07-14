Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # root "users#index"
  root "sessions#new"

  namespace :admin do
    root "dashboard#index"
    resources :employees do
      resources :reports, only: [:index]
    end
    resources :employees
    resources :reports, only: [:index]
  end

  namespace :employees do
    root "dashboard#index"
    resources :time_punches
    resources :reports, only: [:index]
  end

  # resource  :daily_report, only: [:show]
  # resources :users

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
