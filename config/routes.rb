require 'api_constraints'

Rails.application.routes.draw do
  get 'sessions/create'

  get 'sessions/destroy'

  scope module: :api do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#destroy'
      resources :users
      resources :forms do
        resources :reports
      end
    end
  end
end
