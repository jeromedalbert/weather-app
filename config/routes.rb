Rails.application.routes.draw do
  root to: 'weather_forecasts#new'

  resources :weather_forecasts, only: %i[show new create]

  get 'up' => 'rails/health#show', :as => :rails_health_check
end
