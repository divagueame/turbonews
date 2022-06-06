class Article < ApplicationRecord
  validates :url, uniqueness: {case_sensitive: false}
  validates :header, presence: true

  belongs_to :source
  has_many :article_tags, :dependent => :destroy 
  has_many :tags, through: :article_tags, :dependent => :destroy

  include PgSearch::Model

  pg_search_scope :search_all, against: {
    header: 'A',
    body: 'B'
  },
  using: { tsearch: { prefix: true, any_word: true } }

  pg_search_scope :search_header, against: {
    header: 'A'
  },
  using: { tsearch: { prefix: true, any_word: false } }

  pg_search_scope :body_search_terms,  :against => [:body]
end
