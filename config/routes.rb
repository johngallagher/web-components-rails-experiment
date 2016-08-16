Rails.application.routes.draw do
  root "home#show"
  resource :home
  resources :vehicles
  resource :component_updates
  namespace :api do
    namespace :components do
      resource :ac_vehicle_search, only: :show
      resource :ac_vehicle_search_loading, only: :show
    end
  end
end
