Rails.application.routes.draw do
  root "home#show"
  resource :home
  resources :vehicles
  namespace :api do
    namespace :components do
      resource :ac_vehicle_search
    end
  end
end
