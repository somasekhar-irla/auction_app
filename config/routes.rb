require 'sidekiq/web'
require 'sidekiq/cron/web'
# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
Rails.application.routes.draw do

  # Mount the Sidekiq Web UI
  mount Sidekiq::Web => '/sidekiq'

  # Secure Sidekiq with HTTP Basic Authentication
  Sidekiq::Web.use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end

  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope :users, controller: 'users' do
    post  :sign_in
    post  :sign_up
  end

  resources :auction_items, only: [:index, :create]

  resources :bids, only: [:create]
  
  resources :auto_bids, only: [:create]

end
