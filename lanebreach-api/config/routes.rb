Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: 'json'} do
    resources :mobile_metadata, only: [:index, :create]
    resources :sf_311_cases, only: [:index]
    get '/bikeway_networks' => "bikeway_networks#nearest_network"
  end
end
