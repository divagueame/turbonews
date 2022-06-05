class Tag < ApplicationRecord
  validates :name, uniqueness: {case_sensitive: false}
  has_many :article_tags
  has_many :articles, through: :article_tags

  has_many :tag_terms, dependent: :destroy
  has_many :terms, through: :tag_terms
end
