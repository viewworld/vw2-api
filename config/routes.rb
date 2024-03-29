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
        resources :report_files, only: [:show, :create]
      end
      get 'reports', to: 'forms#index_with_reports'
      post 'query', to: 'queries#create'
      resources :transactions, only: :create
      resources :organisations do
        resources :payment_methods
        resource :customer
        resource :subscribtion, only: [:show, :create, :destroy]
      end
      post 'subscribtion_status' => 'subscribtion_statuses#create'
    end
  end
end
