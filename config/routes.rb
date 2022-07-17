Rails.application.routes.draw do
  root to: 'articles#index', get_terms: true
  patch '/terms', to: 'terms#update', as: 'terms'
  get '/admin', to: 'admin#index'
  get '/sources/scrape', to: 'sources#scrape_sources'
  get '/articles/find_all_tags', to: 'articles#index'
  resources :tags
  resources :sources
  resources :articles
  get '/articles/scrape/:id', to: 'articles#scrape_article'
  # root 'articles#index'
end
