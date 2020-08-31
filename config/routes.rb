Rails.application.routes.draw do
  devise_for :users
  resources :cards do
    collection do
      get 'export'
    end
  end

  resources :calendars
  
  resources :categories

  get 'home/index'
  get 'home/export'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
