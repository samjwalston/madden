Rails.application.routes.draw do
  root to: 'home#index'

  resources :import, only: [:create], defaults: {format: :json}
end
