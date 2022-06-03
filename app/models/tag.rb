class Tag < ApplicationRecord
  validates :name, uniqueness: true
  has_many :article_tags
  has_many :articles, through: :article_tags

  has_many :tag_terms, dependent: :destroy
  has_many :terms, through: :tag_terms
end
