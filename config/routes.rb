# config/routes.rb
Rails.application.routes.draw do
  root 'lectures#index'

  resources :lectures, only: [:index, :edit, :update, :new, :create, :destroy] do
    collection do
      post 'import'
    end
  end
end
