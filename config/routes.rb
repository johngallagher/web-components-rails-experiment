Rails.application.routes.draw do
  root "home#show"
  resource :home
  resources :vehicles
end
