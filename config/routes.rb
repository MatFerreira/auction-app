Rails.application.routes.draw do
  root "home#index"

  resources :items, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
