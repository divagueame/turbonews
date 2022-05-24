Rails.application.routes.draw do
  resources :sources
  resources :articles
  get '/scrap', to: 'sources#scrap'
  root "articles#index"
end
