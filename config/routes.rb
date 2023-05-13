Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  authenticate :admin do
    resources :items, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end
end
