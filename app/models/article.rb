class Article < ApplicationRecord
  validates :url, uniqueness: true
  validates :header, presence: true

  belongs_to :source
  has_many :article_tags
  has_many :tags, through: :article_tags

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
end
