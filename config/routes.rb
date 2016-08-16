Rails.application.routes.draw do
  root "home#show"
  resource :home
  resources :vehicles
  resource :component_updates, only: :show
end
