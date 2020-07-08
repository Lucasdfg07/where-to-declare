Rails.application.routes.draw do
  resources :cards
  resources :category

  get 'home/index'
  get 'home/export'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
