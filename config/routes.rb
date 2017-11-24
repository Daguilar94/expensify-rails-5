Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :expenses
    end
  end

  resources :expenses
  get '/dashboard', to: "dashboard#index"
  root "dashboard#index"
end
