Rails.application.routes.draw do
  root to: 'articles#index', get_terms: true
  patch '/terms', to: 'terms#update', as: 'terms'
  get '/terms', to: 'terms#index'
  get '/admin', to: 'admin#index'
  get '/sources/scrape', to: 'sources#scrape_sources'
  get '/articles/find_all_tags', to: 'articles#index'
  post '/articles/find_all_bodies', to: 'articles#update_all'
  post '/terms/find_all_terms', to: 'terms#update_all'
  resources :tags
  resources :sources
  resources :articles
  get '/articles/scrape/:id', to: 'articles#scrape_article'
  # root 'articles#index'
end
