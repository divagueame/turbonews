Rails.application.routes.draw do
  get 'admin', to: 'admin#index'
  resources :tags
  resources :sources
  resources :articles
  get '/scrap', to: 'sources#scrap'
  root "articles#index"
end
