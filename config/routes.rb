Rails.application.routes.draw do
  get 'pages/terms'
  get 'pages/privacy'
  get 'static_pages/top'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'static_pages#top'
  get 'steps/new', to: 'steps#new', as: 'new_step'
  post 'steps/generate', to: 'steps#generate', as: 'generate_step'
  get 'steps/result', to: 'steps#result'

  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'

 if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
 end

  resources :proposals, only: [:new, :index, :show, :destroy] do
    member do
      patch :accepted
      patch :completed
    end
   end

end
