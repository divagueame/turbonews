json.extract! article, :id, :header, :body, :url, :created_at, :updated_at
json.url article_url(article, format: :json)
