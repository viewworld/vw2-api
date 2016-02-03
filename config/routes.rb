require 'api_constraints'

Rails.application.routes.draw do
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#exception'

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
