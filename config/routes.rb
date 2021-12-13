Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'time_sheets#index'  
  resources :time_sheets, only: %i[index new create]
end
