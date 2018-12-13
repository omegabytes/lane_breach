Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    resources :mobile_metadata, only: [:index, :create]

    get '/bikeway_networks', to: 'bikeway_networks#nearest_network'

    resources :sf311_cases, only: [:index, :create]
  end
end
