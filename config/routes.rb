Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  resources :items, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :lots, only: [:show, :new, :create, :update] do
    post 'update_status', on: :member
  end
end
