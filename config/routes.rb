Rails.application.routes.draw do
  get 'admin', to: 'admin#index'
  resources :tags
  resources :sources
  resources :articles
  get '/scrape-all', to: 'sources#scrape_all'
  get '/articles/scrape/:id', to: 'articles#scrape_article'
  root "articles#index"
end
