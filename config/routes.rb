require 'api_constraints'

Rails.application.routes.draw do


  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do

    scope module: :v1, constraints: ApiConstraints.new( version: 1, default: :true ) do
      devise_for :users

      resources :sessions, only: [:create] do
        collection do
          delete :destroy
          get :valid_token
          get :me
        end

      end

      namespace :admin,
                constraints: { subdomain: 'admin' }, path: '/'  do

        resources :users, :only => [:show, :create, :update, :destroy]

      end

    end

  end


end
