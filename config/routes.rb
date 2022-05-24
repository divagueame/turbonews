Rails.application.routes.draw do
  resources :sources
  resources :articles
  
  root "articles#index"
end
