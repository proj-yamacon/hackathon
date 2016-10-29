Rails.application.routes.draw do
  resources :zones
  resources :people
  put '/people/:id/enter', to: 'people#enter'
  put '/people/:id/exit', to: 'people#exit'
end
