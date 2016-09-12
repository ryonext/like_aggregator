Rails.application.routes.draw do
  get 'dashboard/index'
  resources :email
  root "dashboard#index"
end
