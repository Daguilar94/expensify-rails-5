Rails.application.routes.draw do
  resources :expenses
  get '/dashboard', to: "dashboard#index"
  root "dashboard#index"
end
